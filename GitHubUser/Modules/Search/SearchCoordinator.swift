//
//  SearchCoordinator.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import UIKit

final class SearchCoordinator: Coordinator {
    // MARK: Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: Internal

    var navigationController: UINavigationController

    func start() {
        let viewModel = SearchViewModel(githubService: GitHubServiceImpl())
        viewModel.showFollowActionSheet = showFollowActionSheet
        let controller = SearchViewController(view: viewModel)
        push(controller: controller)
    }

    // MARK: Private

    private func showFollowActionSheet(_ user: User) {
        let alertController = UIAlertController(title: "\(user.login)'s follows & followings", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Dismiss", style: .cancel)
        cancel.styleTextColor(color: .black)
        let followers = UIAlertAction(title: "Followers", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.goToFollow(isFollowers: true, user: user)
        }
        followers.applyStyling(with: #imageLiteral(resourceName: "icon-follow"))
        let following = UIAlertAction(title: "Following", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.goToFollow(isFollowers: false, user: user)
        }
        following.applyStyling(with: #imageLiteral(resourceName: "icon-following"))
        alertController.addAction(following)
        alertController.addAction(followers)
        alertController.addAction(cancel)
        present(controller: alertController)
    }

    private func goToFollow(isFollowers: Bool, user: User) {
        let coordinator = FollowCoordinator(
            navigationController: navigationController,
            isFollowers: isFollowers,
            user: user
        )
        coordinate(to: coordinator)
    }
}
