import UIKit
import Kingfisher

final class CollectionDetailsNftListCellView: UICollectionViewCell {
    
    static let identifier = "CollectionCell"
    
    var viewModel: NftCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }
    
    private var isInCart: Bool = false
    
    // MARK: - Layout Element Properties
    
    // Constants
    
    let stackSpacingHalf: CGFloat = 4
    let stackSpacing: CGFloat = 8
    
    // Properties
    
    private lazy var avatarView = NftAvatarView()
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
    
    private lazy var cartButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addToCart")
        imageView.tintColor = .asset(.main(.primary))
        imageView.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(cartButtonTapped))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    // MARK: - Stacks
    
    private lazy var vStackRating: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rating])
        stack.axis = .vertical
        stack.alignment = .leading
        return stack
    }()
    
    private lazy var vStackTitlePrice: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = stackSpacingHalf
        return stack
    }()
    
    private lazy var hStackTitlePriceCart: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [vStackTitlePrice, cartButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var vStackRateTitlePriceCart: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [vStackRating, hStackTitlePriceCart])
        stack.axis = .vertical
        stack.spacing = stackSpacingHalf
        return stack
    }()
    
    private lazy var vStackMain: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, vStackRateTitlePriceCart])
        stack.axis = .vertical
        stack.spacing = stackSpacing
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
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            // TODO: make var
            avatarView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            avatarView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalTo: cartButton.widthAnchor),
        ])
    }
    
    func configure(with viewModel: NftCellViewModel) {
        self.viewModel = viewModel
    }
    
    // MARK: - Private Methods
    
    private func didUpdateViewModel() {
        avatarView.viewModel = .init(
            imageSize: .large,
            imageURL: viewModel?.imageURL,
            isLiked: false,
            likeButtonAction: { return }
        )
        rating.rating = viewModel?.rating
        titleLabel.text = viewModel?.name
        priceLabel.text = viewModel?.price
    }

    @objc private func cartButtonTapped() {
        isInCart.toggle()
        updateCartButtonImage()
    }
    
    private func updateCartButtonImage() {
        if isInCart {
            cartButton.image = UIImage(named: "deleteFromCart")
        } else {
            cartButton.image = UIImage(named: "addToCart")
        }
    }
}
