//
//  PaginationType.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import RxRelay
import RxSwift

public protocol PaginationType {
    var maxValue: Int { get }
    var fetchPerPage: Int { get }
    var pageNumber: BehaviorRelay<Int> { get }
    var pageNumberObservable: Observable<Int> { get }
}
