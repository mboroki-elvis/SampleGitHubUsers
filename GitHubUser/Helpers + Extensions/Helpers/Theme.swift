//
//  Theme.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Foundation
import UIKit

enum Theme {
    case `default`

    // MARK: Internal

    func apply() {
        switch self {
        case .default:
            defaultTheme()
        }
    }

    // MARK: Private

    private func defaultTheme() {
        UINavigationBar.appearance().barTintColor = UIColor(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)
        ]
    }
}
