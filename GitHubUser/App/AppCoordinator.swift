//
//  AppCoordinator.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    // MARK: Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Internal

    var navigationController: UINavigationController

    func start() {
        let coordinator = SearchCoordinator(navigationController: navigationController)
        coordinate(to: coordinator)
    }
}
