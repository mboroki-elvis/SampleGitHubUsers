//
//  ViewModelType.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import Foundation
import RxRelay

public protocol ViewModelType {
    associatedtype Input
    associatedtype Output
}
