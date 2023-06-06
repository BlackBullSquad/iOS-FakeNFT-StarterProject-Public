//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

class MyNFTTableViewCell: UITableViewCell {
    static let identifier = "MyNFTTableViewCell"
    
    // MARK: - Properties
    private let nftView: NFTAvatarView = NFTAvatarView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.text = "от John Doe"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.asset(Asset.main(.backround))
        label.text = "Цена"
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.asset(Asset.main(.backround))
        return label
    }()
    
    private lazy var ratingView = RatingView()
    
    private let firstVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let priceVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    var likeButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with nft: NFT, isLiked: Bool) {
        nftView.viewModel = NFTAvatarViewModel(imageSize: .large, imageURL: nft.images.first, isLiked: isLiked) { [weak self] in
            self?.likeButtonAction?()
            print("liked")
        }
        nameLabel.text = nft.name
        ratingView.rating = nft.rating
        priceValueLabel.text = "\(nft.price) ETH"
    }
    
    private func layout() {
        [nameLabel,
         ratingView,
         authorLabel
        ].forEach { view in
//            view.translatesAutoresizingMaskIntoConstraints = false
            firstVerticalStackView.addArrangedSubview(view)
        }
        
        [priceLabel,
         priceValueLabel
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            priceVerticalStackView.addArrangedSubview(view)
        }
        
        [nftView,
         firstVerticalStackView,
         priceVerticalStackView
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            firstVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            firstVerticalStackView.leadingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: 20),
            firstVerticalStackView.trailingAnchor.constraint(equalTo: priceVerticalStackView.leadingAnchor, constant: -16),
            
            priceVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            priceVerticalStackView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -114),
            priceVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
