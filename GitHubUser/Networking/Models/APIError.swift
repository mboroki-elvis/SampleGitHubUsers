//
//  SearchError.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Foundation

enum APIError: Error, Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
    
    case underlyingError(Error)
    case notFound
    case unkowned
}
