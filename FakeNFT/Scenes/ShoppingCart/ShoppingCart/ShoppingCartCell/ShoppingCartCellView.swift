import UIKit

final class ShoppingCartCellView: UITableViewCell {
    var viewModel: ShoppingCartCellViewModel? { didSet { viewModelDidUpdate() } }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var avatar = NFTAvatarView()

    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .asset(.black)
        button.setImage(.asset(.deleteFromCart), for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .asset(.bold17)
        label.textAlignment = .natural
        return label
    }()

    private lazy var ratingView = RatingView()

    private lazy var priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.textColor = .asset(.black)
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .asset(.bold17)
        label.textAlignment = .natural
        return label
    }()

    private lazy var ratingVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingView])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        return stack
    }()

    private lazy var priceVStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [priceTitleLabel, priceLabel])
        stack.axis = .vertical
        stack.alignment = .leading
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
}

// MARK: - Lifecycle

extension ShoppingCartCellView {
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }

    private func viewModelDidUpdate() {
        guard let viewModel else { return }

        titleLabel.text = viewModel.name
        priceLabel.text = viewModel.priceLabel
        avatar.viewModel = .init(imageSize: .large,
                                 imageURL: viewModel.avatarUrl,
                                 likeButtonAction: nil)
        ratingView.rating = viewModel.rating
    }

    private func resetView() {
        titleLabel.text = nil
        priceLabel.text = nil
        avatar.viewModel = .init(imageSize: .large,
                                 imageURL: nil,
                                 likeButtonAction: nil)
        ratingView.rating = nil
    }
}

// MARK: - Initial Setup

private extension ShoppingCartCellView {
    func setupSubviews() {
        backgroundColor = .asset(.white)

        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - User Action

private extension ShoppingCartCellView {
    @objc func didTapDeleteButton() {
        viewModel?.onDelete()
    }
}
