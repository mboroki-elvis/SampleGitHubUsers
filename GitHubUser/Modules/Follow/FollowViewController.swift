//
//  FollowController.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Foundation
import RxSwift
import UIKit

final class FollowViewController: BaseTableViewController<FollowViewModel> {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCells()
        setupInputs()
        setupOutputs()
        setupViewController()
    }

    override func setupViewController() {
        switch model.isFollowers {
        case true:
            title = "\(model.user.login)'s followers"
        case false:
            title = "\(model.user.login) follows"
        }
    }

    // MARK: Private

    private let disposeBag = DisposeBag()

    private func setupInputs() {
        model
            .output
            .content?
            .drive(tableView.rx.items(cellIdentifier: UserCell.identifier, cellType: UserCell.self)) { _, datasource, cell in
                cell.datasource = datasource
            }.disposed(by: disposeBag)

        model
            .output
            .error
            .drive { observable in
                observable.flatMap { error in
                    NotificationsHelper.error(error.localizedDescription)
                }?.show()
            }.disposed(by: disposeBag)

        model
            .output
            .isLoading
            .drive(rx.showLoadingView)
            .disposed(by: disposeBag)
    }

    private func setupOutputs() {
        model.input.viewDidLoad.accept(())
    }

    private func setupCells() {
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
    }
}
