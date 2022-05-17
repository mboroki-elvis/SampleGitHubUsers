//
//  MockGitHubService.swift
//  GitHubUserTests
//
//  Created by Elvis Mwenda on 17/05/2022.
//

import Foundation
@testable import GitHubUser
import RxSwift

final class MockGitHubService: GitHubService {
    // MARK: Lifecycle

    init() {}

    // MARK: Internal

    func following(user name: String) -> Single<[User]> {
        let users = Bundle.main.decode([User].self, from: "GitHubeUserFollowing.json")
        return .just(users)
    }

    func followers(user name: String) -> Single<[User]> {
        let users = Bundle.main.decode([User].self, from: "GitHubUserFollower.json")
        return .just(users)
    }

    func search(search model: GitHubTarget.GitHubSearchModel) -> Single<SearchResponse> {
        guard !model.queryString.isEmpty else { return .never() }
        let response = Bundle.main.decode(SearchResponse.self, from: "GitHubUser.json")
        return .just(response)
    }
}
