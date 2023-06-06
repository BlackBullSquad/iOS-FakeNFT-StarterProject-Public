import UIKit
import Kingfisher

final class CollectionCell: UICollectionViewCell {
    
    static let collectionIdentifier = "CollectionCell"
    
    var viewModel: NftCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }
    
    private lazy var avatarView = NFTAvatarView()
    
    private lazy var rating = RatingView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .asset(.bold17)
        label.textColor = .asset(.main(.primary))
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .asset(.medium10)
        label.textColor = .asset(.main(.primary))
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var vStackNamePrice: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel ])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStackRateVstackNamePrice: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rating, vStackNamePrice])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStackMain: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, vStackRateVstackNamePrice])
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = .asset(.additional(.white))
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }

    
    // MARK: - Setup
    
    private func setupSubviews() {
        contentView.addSubview(vStackMain)
        
        NSLayoutConstraint.activate([
            vStackMain.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStackMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
    }
    
    private func didUpdateViewModel() {
        print("APPLYING MODEL")
        avatarView.viewModel = .init(imageSize: .large,
                                     imageURL: viewModel?.imageURL,
                                     isLiked: false,
                                     likeButtonAction: { return })
        rating.rating = viewModel?.rating
        titleLabel.text = viewModel?.name
        priceLabel.text = viewModel?.price
    }
    
    func configure(with viewModel: NftCellViewModel) {
        self.viewModel = viewModel
    }
}

