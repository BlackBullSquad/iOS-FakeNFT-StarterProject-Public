//
//  MyNFTTableViewCell.swift
//  FakeNFT
//
//  Created by MacBook on 01.06.2023.
//

import UIKit

class MyNftTableViewCell: UITableViewCell {
    static let identifier = "MyNftTableViewCell"
    
    // MARK: - Properties
    private let nftView: NFTAvatarView = NFTAvatarView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.text = "от John Doe"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .label
        label.text = "Цена"
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let ratingView = RatingView()
    
    private lazy var firstVerticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel,
                                                       ratingView,
                                                       authorLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }()

    private let priceVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    var likeButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        selectionStyle = .none
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(with nft: NFT, isLiked: Bool) {
        nftView.viewModel = NFTAvatarViewModel(imageSize: .large, imageURL: nft.images.first, isLiked: isLiked) { [weak self] in
            self?.likeButtonAction?()
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
            view.translatesAutoresizingMaskIntoConstraints = false
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
            self.contentView.addSubview(view)
        }
        
        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            firstVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            firstVerticalStackView.leadingAnchor.constraint(equalTo: nftView.trailingAnchor, constant: 20),
            
            priceVerticalStackView.centerYAnchor.constraint(equalTo: nftView.centerYAnchor),
            priceVerticalStackView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -114),
            priceVerticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
