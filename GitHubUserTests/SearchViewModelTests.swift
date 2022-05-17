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
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func testSearchWithSuccess() throws {
        // create scheduler
        let disposeBag = DisposeBag()
        let service = MockGitHubService()
        let scheduler = TestScheduler(initialClock: 0)
        
        let observer = scheduler.createObserver([User].self)
        let expected = Bundle.main.decode(SearchResponse.self, from: "GitHubUser.json").items
        let source = scheduler.createColdObservable([.next(5, "tom"), .completed(10)])
       
        let viewModel = SearchViewModel(githubService: service)

        // mock a search
        source.bind(to: viewModel.input.search).disposed(by: disposeBag)

        // bind the result
        viewModel.output.content?.drive(observer).disposed(by: disposeBag)
        
        scheduler.start()

        XCTAssertEqual(observer.events, [.next(0, []), .next(5, expected)])
    }

    func testSearchWithError() throws {
        // create scheduler
        let disposeBag = DisposeBag()
        let service = MockGitHubService()
        let scheduler = TestScheduler(initialClock: 0)
        
        let observer = scheduler.createObserver(APIError.self)
        let source = scheduler.createColdObservable([.next(5, ""), .completed(10)])
        
        let viewModel = SearchViewModel(githubService: service)
        
        // mock a search
        source.bind(to: viewModel.input.search).disposed(by: disposeBag)
        
        // bind the result
        viewModel
            .output
            .error
            .drive { observable in
                observable.flatMap { error in
                    observer.onNext(error)
                }
            }.disposed(by: disposeBag)

        scheduler.start()
        XCTAssertEqual(observer.events, [.next(0, .notFound), .next(5, .notFound)])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
