//
//  SearchController.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import RxSwift
import UIKit

final class SearchViewController: BaseTableViewController<SearchViewModel> {
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupCells()
        setupSearchController()
        setupInputs()
        setupOutputs()
    }

    override func setupViewController() {
        title = "GitHub Users 🧑🏽‍💻"
    }

    // MARK: Private

    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)

    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search users..."
        navigationItem.searchController = searchController
    }

    private func setupCells() {
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
    }

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
            .map(!)
            .drive(rx.showLoadingView)
            .disposed(by: disposeBag)
    }

    private func setupOutputs() {
        searchController
            .searchBar
            .rx
            .text
            .orEmpty
            .bind(to: model.input.search)
            .disposed(by: disposeBag)

        tableView
            .rx
            .modelSelected(User.self)
            .bind(to: model.input.didSelectModel)
            .disposed(by: disposeBag)

        tableView
            .rx
            .willDisplayCell
            .flatMap { _, indexPath -> Observable<(section: Int, row: Int)> in
                Observable.of((indexPath.section, indexPath.row))
            }
            .filter { [weak self] section, row in
                guard let self = self else { return false }
                let numberOfSections = self.tableView.numberOfSections
                let numberOfRows = self.tableView.numberOfRows(inSection: section)
                return section == numberOfSections - 1 && row == numberOfRows - 1
            }
            .map { _ in () }
            .bind(to: model.input.didScrollToBottom)
            .disposed(by: disposeBag)
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}
