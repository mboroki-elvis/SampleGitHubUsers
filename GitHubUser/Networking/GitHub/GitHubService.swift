//
//  GitHubService.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Alamofire
import Foundation
import Moya
import RxMoya
import RxSwift

protocol GitHubService {
    func following(user name: String) -> Single<[User]>
    func followers(user name: String) -> Single<[User]>
    func search(search model: GitHubTarget.GitHubSearchModel) -> Single<SearchResponse>
}

final class GitHubServiceImpl: GitHubService {
    // MARK: Lifecycle

    init() {
        provider = MoyaProvider<GitHubTarget>()
    }

    // MARK: Internal

    func search(search model: GitHubTarget.GitHubSearchModel) -> Single<SearchResponse> {
        executeRequest(target: .searchUsers(model))
    }

    func followers(user name: String) -> Single<[User]> {
        executeRequest(target: .followers(name))
    }

    func following(user name: String) -> Single<[User]> {
        executeRequest(target: .following(name))
    }

    // MARK: Private

    private let provider: MoyaProvider<GitHubTarget>

    private func executeRequest<Response>(target: GitHubTarget) -> Single<Response> where Response: Decodable {
        provider.rx.request(target).flatMap { response in
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(Response.self, from: response.data)
                return .just(decodedResponse)
            } catch {
                print(error)
                log.error(.init(stringLiteral: error.localizedDescription))
                return .error(error)
            }
        }
    }
}
