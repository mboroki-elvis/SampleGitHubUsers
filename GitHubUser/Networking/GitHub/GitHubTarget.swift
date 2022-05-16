//
//  GitHubTarget.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Foundation
import Moya

enum GitHubTarget {
    case searchUsers(GitHubSearchModel)
    case followers(String)
    case following(String)

    // MARK: Internal

    struct GitHubSearchModel {
        var queryString: String
        var order: String = "desc"
        var sort: String? = "followers"
        var page: Int = 1
        var per_page: Int = 10
    }
}

extension GitHubTarget: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }

    public var path: String {
        switch self {
        case .searchUsers:
            return "/search/users"
        case .followers(let username):
            return "users/\(username)/followers"
        case .following(let username):
            return "users/\(username)/following"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .searchUsers:
            return .get
        case .followers:
            return .get
        case .following:
            return .get
        }
    }

    public var sampleData: Data {
        return Data()
    }

    public var task: Task {
        switch self {
        case .followers,
             .following:
            return .requestPlain
        case .searchUsers(let model):
            var params = [String: Any]()
            params["q"] = model.queryString
            params["order"] = model.order
            if let sort = model.sort {
                params["sort"] = sort
            }
            params["page"] = model.page
            params["per_page"] = model.per_page
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json", "Accept": "application/vnd.github.v3+json"]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
