//
//  BaseTableViewController.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 15/05/2022.
//

import UIKit

class BaseTableViewController<T: ViewModelType>: UIViewController, UITableViewDelegate {
    // MARK: Lifecycle

    init(view model: T) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    let model: T

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        return tableView
    }()

    var showLoadingView: Bool? {
        didSet {
            guard let show = showLoadingView else { return }
            showLoadingMore(show)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }

    // MARK: Private

    private var tableFooterView: UIView? {
        get {
            return tableView.tableFooterView
        }
        set {
            tableView.tableFooterView = newValue
        }
    }

    private func layout() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
        ])
    }

    private func showLoadingMore(_ bool: Bool) {
        switch bool {
        case true:
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
            let activityView = UIActivityIndicatorView(style: .large)
            activityView.startAnimating()
            activityView.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(activityView)
            let contraints = [
                activityView.topAnchor.constraint(equalTo: footerView.topAnchor),
                activityView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
                activityView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
                activityView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            ]
            NSLayoutConstraint.activate(contraints)
            tableFooterView = footerView
        case false:
            tableFooterView = nil
        }
    }
    
    func setupViewController() {
        
    }
}
