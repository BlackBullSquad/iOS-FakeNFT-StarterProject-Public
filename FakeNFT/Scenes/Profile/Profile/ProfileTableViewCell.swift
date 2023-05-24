//
//  ProfileTableViewCell.swift
//  FakeNFT
//
//  Created by Filosuf on 21.05.2023.
//

import UIKit

final class ProfileTableViewCell: UITableViewCell {
    static let identifier = "ProfileTableViewCell"

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .label
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(label: String) {
        titleLabel.text = label
    }

    private func layout() {
        [titleLabel,
         arrowImage
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            arrowImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
}
