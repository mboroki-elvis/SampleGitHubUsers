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
        let color = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        setValue(color, forKey: "titleTextColor")
        setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
    }

    func styleTextColor(color: UIColor) {
        setValue(color, forKey: "titleTextColor")
    }
}

extension UIAlertController {
    func applyStyling(with title: String) {
        let color = UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if UITraitCollection.userInterfaceStyle == .dark {
                return UIColor.white
            } else {
                return UIColor.black
            }
        }
        let titleFont = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: color
        ]
        let titleAttrString = NSMutableAttributedString(string: title, attributes: titleFont)
        setValue(titleAttrString, forKey: "attributedTitle")
    }
}
