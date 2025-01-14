import UIKit
import Kingfisher

private enum CartState {
    case added, removed
}

final class NftListView: UICollectionViewCell {

    static let identifier = "CollectionCell"

    private var cartState: CartState = .removed {
        didSet {
            updateCartButtonImage()
        }
    }

    var viewModel: NftCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }

    // MARK: - Layout Element Properties

    // Constants

    private let stackSpacingHalf: CGFloat = 4
    private let stackSpacing: CGFloat = 8

    // Properties

    private lazy var avatarView = NftAvatarView()
    private lazy var rating = RatingView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .asset(.bold17)
        label.textColor = .asset(.main(.primary))
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .asset(.medium10)
        label.textColor = .asset(.main(.primary))
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
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

        let avatarSize = contentView.widthAnchor
        let cartIconSize: CGFloat = 40

        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalTo: avatarSize),
            avatarView.heightAnchor.constraint(equalTo: avatarSize),

            cartButton.widthAnchor.constraint(equalToConstant: cartIconSize),
            cartButton.heightAnchor.constraint(equalToConstant: cartIconSize),

            vStackMain.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vStackMain.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    func configure(with viewModel: NftCellViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Reuse Preparation

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        priceLabel.text = nil
        avatarView.viewModel = nil
        rating.rating = 0
        cartButton.image = nil
        viewModel = nil
    }

    // MARK: - Private Methods

    private func didUpdateViewModel() {
        avatarView.viewModel = .init(
            imageURL: viewModel?.imageURL,
            isLiked: viewModel?.isLiked ?? false,
            likeButtonAction: { [weak self] in self?.likeButtonTapped() }
        )
        rating.rating = viewModel?.rating
        titleLabel.text = viewModel?.name
        priceLabel.text = viewModel?.price
        updateCartState()
    }

    private func updateCartState() {
        cartState = viewModel?.isInCart == true ? .added : .removed
    }

    @objc private func cartButtonTapped() {
        viewModel?.toggleCartStatus()
        updateCartState()
    }

    private func updateCartButtonImage() {
        cartButton.image = cartState.image
    }

    private func likeButtonTapped() {
        viewModel?.toggleLike()
        didUpdateViewModel()
    }
}

private extension CartState {
    var image: UIImage {
        switch self {
        case .added:
            return UIImage(named: "deleteFromCart")!
        case .removed:
            return UIImage(named: "addToCart")!
        }
    }
}
