//
//  NotificationsHelper.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import SwiftMessages
import UIKit

enum NotificationsHelper {
    case error(String)
    case warning(String)
    case message(String)

    // MARK: Internal

    func show() {
        // Instantiate a message view from the provided card view layout. SwiftMessages searches for nib
        // files in the main bundle first, so you can easily copy them into your project and make changes.
        let view = MessageView.viewFromNib(layout: .cardView)

        switch self {
        case .error(let string):
            view.configureTheme(.error)
            view.configureContent(title: "Error 👎🏽", body: string)
        case .warning(let string):
            view.configureTheme(.warning)
            view.configureContent(title: "Be warned ⚠️", body: string)
        case .message(let string):
            view.configureTheme(.info)
            view.configureContent(title: "Hey, there 👋🏽", body: string)
        }

        view.configureDropShadow()
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button = nil
        SwiftMessages.show(view: view)
    }
}
