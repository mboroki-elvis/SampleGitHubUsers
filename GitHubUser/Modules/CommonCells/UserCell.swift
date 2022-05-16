//
//  SearchCell.swift
//  GitHubUser
//
//  Created by Elvis Mwenda on 16/05/2022.
//

import Kingfisher
import UIKit

final class UserCell: UITableViewCell, CellType {
    // MARK: Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal

    var datasource: Any? {
        didSet {
            guard let source = datasource as? User else { return }
            if let url = URL(string: source.avatarURL) {
                profileImageView.kf.setImage(with: url)
            }
            userNameLabel.text = source.login
        }
    }

    func setupView() {
        selectionStyle = .none
        contentView.addSubview(userNameLabel)
        contentView.addSubview(profileImageView)
        let constraints = [
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImageView.trailingAnchor.constraint(equalTo: userNameLabel.leadingAnchor, constant: -8),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            userNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ]
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        print(profileImageView.frame.width / 2)
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: Private

    private let profileImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
