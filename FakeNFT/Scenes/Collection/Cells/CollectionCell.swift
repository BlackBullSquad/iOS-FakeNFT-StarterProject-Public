import UIKit
import Kingfisher

final class CollectionCell: UICollectionViewCell {
    
    static let identifier = "CollectionCell"
    
    var viewModel: NftCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }
    
    private var isInCart: Bool = false
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

    
    lazy var vStackNamePrice: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, priceLabel ])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    lazy var hStackNamePriceCart: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [vStackNamePrice, cartButton])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStackRateHstack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [rating, hStackNamePriceCart])
        stack.axis = .vertical
        stack.spacing = 5
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var vStackMain: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarView, vStackRateHstack])
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
            
            avatarView.widthAnchor.constraint(equalTo: vStackMain.widthAnchor),
            avatarView.heightAnchor.constraint(equalTo: vStackMain.widthAnchor),
            
            vStackNamePrice.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            
            vStackMain.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStackMain.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStackMain.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStackMain.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -21)
        ])
    }
    
    func configure(with viewModel: NftCellViewModel) {
        self.viewModel = viewModel
    }


    // MARK: - Private Methods
    
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
