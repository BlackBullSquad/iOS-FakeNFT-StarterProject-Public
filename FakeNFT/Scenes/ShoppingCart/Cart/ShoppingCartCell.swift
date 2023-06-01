import UIKit

final class ShoppingCartCell: UITableViewCell {
    static let identifier = "CartCell"

    var priceFormatter: NumberFormatter?
    var onDelete: (() -> Void)?

    // MARK: - Components

    private lazy var avatar = NFTAvatarView()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .asset(.main(.primary))
        button.setImage(.init(named: "deleteFromCart"), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .left
        return label
    }()

    private lazy var ratingView = RatingView()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .left
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .left
        return label
    }()

    private lazy var ratingVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingView])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()

    private lazy var priceVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [ratingVStack, priceVStack])
        stack.axis = .vertical
        stack.spacing = 12
        return stack
    }()

    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatar, vStack, UIView(), deleteButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupSubviews() {
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    override func prepareForReuse() {
        configure(nil, onDelete: nil)
    }
}

// MARK: - Configuration

extension ShoppingCartCell {
    func configure(_ viewModel: ItemViewModel?, onDelete: (() -> Void)?) {
        guard let viewModel else {
            titleLabel.text = ""
            priceLabel.text = ""
            avatar.viewModel = .init(imageSize: .large, imageURL: nil, likeButtonAction: nil)
            ratingView.rating = nil
            self.onDelete = nil
            return
        }

        guard let priceFormatter else { preconditionFailure("cell was not set up properly") }

        titleLabel.text = viewModel.name
        let priceString = priceFormatter.string(from: .init(value: viewModel.price)) ?? ""
        priceLabel.text = "\(priceString) ETH"
        avatar.viewModel = .init(imageSize: .large,
                                 imageURL: viewModel.avatarUrl,
                                 likeButtonAction: nil)
        ratingView.rating = viewModel.rating
        self.onDelete = onDelete
    }
}

// MARK: - Action

extension ShoppingCartCell {
    @objc func didTapDeleteButton() {
        onDelete?()
    }
}
