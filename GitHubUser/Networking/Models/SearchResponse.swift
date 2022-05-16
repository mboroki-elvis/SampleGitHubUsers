//
//  SearchResponse.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Foundation

struct SearchResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }

    let totalCount: Int
    let incompleteResults: Bool
    let items: [User]
}
