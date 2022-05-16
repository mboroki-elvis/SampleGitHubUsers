//
//  Coordinator.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
    func coordinate(to coordinator: Coordinator)
    var navigationController: UINavigationController { get }
    init(navigationController: UINavigationController)
    func push(controller: UIViewController)
}

extension Coordinator {
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }

    func push(controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }

    func present(controller: UIViewController) {
        navigationController.present(controller, animated: true)
    }
}
