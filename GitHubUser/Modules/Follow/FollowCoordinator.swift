//
//  FollowCoordinator.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import UIKit

final class FollowCoordinator: Coordinator {
    // MARK: Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    convenience init(navigationController: UINavigationController, isFollowers: Bool, user: User) {
        self.init(navigationController: navigationController)
        self.user = user
        self.isFollowers = isFollowers
    }

    // MARK: Internal

    private(set) var navigationController: UINavigationController

    func start() {
        guard let isFollowers = isFollowers, let user = user else { return }
        let viewModel = FollowViewModel(isFollowers: isFollowers, user: user)
        let controller = FollowViewController(view: viewModel)
        push(controller: controller)
    }

    // MARK: Private

    private var user: User?
    private var isFollowers: Bool?
}
