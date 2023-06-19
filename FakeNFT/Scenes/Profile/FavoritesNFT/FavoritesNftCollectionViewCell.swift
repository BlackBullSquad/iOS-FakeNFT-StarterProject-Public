//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by MacBook on 04.06.2023.
//

import UIKit

class FavoritesNftCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "FavoritesNftCollectionViewCell"

    // MARK: - Properties
    private let nftView: NftAvatarView = NftAvatarView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()

    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        return label
    }()

    private let ratingView = RatingView()

    private lazy var firstVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, ratingView, priceValueLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    var likeButtonAction: (() -> Void)?

    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(with nft: Nft) {
        nftView.viewModel = NftAvatarViewModel(
            imageURL: nft.images.first,
            isLiked: true
        ) { [weak self] in
            self?.likeButtonAction?()
        }
        nameLabel.text = nft.name
        ratingView.rating = nft.rating
        priceValueLabel.text = "\(nft.price) ETH"
    }

    private func layout() {
        [nameLabel, ratingView, priceValueLabel].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            firstVerticalStackView.addArrangedSubview(view)
        }

        [nftView, firstVerticalStackView].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        let nftViewSize: CGFloat = 80

        NSLayoutConstraint.activate([
            nftView.widthAnchor.constraint(equalToConstant: nftViewSize),
            nftView.heightAnchor.constraint(equalToConstant: nftViewSize),
            nftView.topAnchor.constraint(equalTo: topAnchor),
            nftView.leadingAnchor.constraint(equalTo: leadingAnchor),

            firstVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            firstVerticalStackView.leadingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: 12),
            firstVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstVerticalStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
}
