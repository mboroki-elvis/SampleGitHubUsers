//
//  FollowingViewModelTests.swift
//  GitHubUserTests
//
//  Created by Elvis Mwenda on 15/05/2022.
//

@testable import GitHubUser
import RxBlocking
import RxSwift
import RxTest
import XCTest

final class FollowingViewModelTests: XCTestCase {
    // MARK: Internal

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testFollowingsFound() throws {
        // create scheduler
        let disposeBag = DisposeBag()
        let service = MockGitHubService()
        let scheduler = TestScheduler(initialClock: 0)

        let observer = scheduler.createObserver([User].self)
        let expected = Bundle.main.decode([User].self, from: "GitHubeUserFollowing.json")
        let source = scheduler.createColdObservable([.next(5, ()), .completed(10)])

        let response = Bundle.main.decode(SearchResponse.self, from: "GitHubUser.json")
        if let model = response.items.first {
            let viewModel = FollowViewModel(isFollowers: false, user: model, githubService: service)

            // mock a search
            source.bind(to: viewModel.input.viewDidLoad).disposed(by: disposeBag)

            // bind the result
            viewModel.output.content?.drive(observer).disposed(by: disposeBag)

            scheduler.start()

            XCTAssertEqual(observer.events, [.next(5, expected)])
        }
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
    private var viewModel: FollowViewModel!

    private var service: MockGitHubService!
}
