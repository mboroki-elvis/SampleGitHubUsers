//
//  SearchError.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Foundation

enum APIError: Error {
    case underlyingError(Error)
    case notFound
    case unkowned
}
