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

final class FollowerViewModelTests: XCTestCase {
    // MARK: Internal

    override func setUpWithError() throws {
        self.disposeBag = DisposeBag()
        self.service = MockGitHubService()
        self.scheduler = TestScheduler(initialClock: 0)
        let response = Bundle.main.decode(SearchResponse.self, from: "GitHubUser.json")
        if let model = response.items.first {
            self.viewModel = FollowViewModel(isFollowers: true, user: model, githubService: self.service)
        }
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        self.service = nil
        self.scheduler = nil
        self.disposeBag = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
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
