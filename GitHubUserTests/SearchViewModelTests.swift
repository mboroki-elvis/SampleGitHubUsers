//
//  GitHubUserTests.swift
//  GitHubUserTests
//
//  Created by Elvis Mwenda on 15/05/2022.
//

@testable import GitHubUser
import RxBlocking
import RxSwift
import RxTest
import XCTest

private class SearchViewModelTests: XCTestCase {
    // MARK: Internal

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
        self.service = MockGitHubService()
        self.scheduler = TestScheduler(initialClock: 0)
        self.viewModel = SearchViewModel(githubService: self.service)
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.viewModel = nil
        self.service = nil
        self.scheduler = nil
        self.disposeBag = nil
    }

    func testSearchWithSuccess() throws {
        // create scheduler
        let observer = self.scheduler.createObserver([User].self)
        let expected = Bundle.main.decode(SearchResponse.self, from: "GitHubUser.json").items

        // bind the result
        self.viewModel
            .output
            .content?
            .drive(observer)
            .disposed(by: self.disposeBag)

        // mock a search
        self.scheduler
            .createColdObservable([.next(10, "tom")])
            .bind(to: self.viewModel.input.search)
            .disposed(by: self.disposeBag)

        self.scheduler.start()

        XCTAssertEqual(observer.events, [.next(0, []), .next(10, expected)])
    }

    func testSearchWithError() throws {
        let observer = self.scheduler.createObserver(APIError.self)

        // bind the result
        self.viewModel
            .output
            .error
            .drive { observable in
                observable.flatMap { error in
                    observer.onNext(error)
                }
            }.disposed(by: self.disposeBag)

        // mock a search
        self.scheduler
            .createColdObservable([.next(5, ""), .next(10, ""), .next(15, "")])
            .bind(to: self.viewModel.input.search)
            .disposed(by: self.disposeBag)

        self.scheduler.start()
        XCTAssertEqual(observer.events, [.next(0, .notFound), .next(5, .notFound), .next(10, .notFound), .next(15, .notFound)])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: Private

    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private var viewModel: SearchViewModel!

    private var service: MockGitHubService!
}
