//
//  UIKit+Extensions.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIAlertAction {
    func applyStyling(with image: UIImage) {
        setValue(image, forKey: "image")
        setValue(UIColor.black, forKey: "titleTextColor")
        setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
    }

    func styleTextColor(color: UIColor) {
        setValue(color, forKey: "titleTextColor")
    }
}
