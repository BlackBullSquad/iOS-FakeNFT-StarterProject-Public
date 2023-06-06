//
//  FavoritesNFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by MacBook on 04.06.2023.
//

import UIKit

class FavoritesNFTCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "FavoritesNFTCollectionViewCell"

    // MARK: - Properties
    private let nftView: NFTAvatarView = NFTAvatarView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
//        label.translatesAutoresizingMaskIntoConstraints = false
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
    
//    private lazy var ratingVStack: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingView])
//        stack.axis = .vertical
//        stack.alignment = .leading
//        stack.spacing = 4
//        return stack
//    }()
    
    var likeButtonAction: (() -> Void)?
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with nft: NFT) {
        nftView.viewModel = NFTAvatarViewModel(imageSize: .small, imageURL: nft.images.first, isLiked: true) { [weak self] in
            self?.likeButtonAction?()
            print("liked")
        }
        nameLabel.text = nft.name
        ratingView.rating = nft.rating
        priceValueLabel.text = "\(nft.price) ETH"
    }
    
    private func layout() {
//        [nameLabel,
//         ratingView,
//         priceValueLabel
//        ].forEach { view in
//            view.translatesAutoresizingMaskIntoConstraints = false
//            firstVerticalStackView.addArrangedSubview(view)
//        }
        
        [nftView,
         firstVerticalStackView,
//         ratingView
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: topAnchor),
            nftView.leadingAnchor.constraint(equalTo: leadingAnchor),
            
//            ratingView.widthAnchor.constraint(equalTo: firstVerticalStackView.widthAnchor),
//            ratingView.topAnchor.constraint(equalTo: firstVerticalStackView.bottomAnchor, constant: 10),
//            ratingView.leadingAnchor.constraint(equalTo: firstVerticalStackView.leadingAnchor),
            
            firstVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            firstVerticalStackView.leadingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: 12),
            firstVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            firstVerticalStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
}
