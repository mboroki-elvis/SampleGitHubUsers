//
//  CellType.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Foundation

public protocol CellType {
    var datasource: Any? { get set }
    func setupView()
}
