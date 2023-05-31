import UIKit

final class CartCell: UITableViewCell {
    static let identifier = "CartCell"
    var priceFormatter: NumberFormatter?

    private lazy var avatar = NFTAvatarView()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .left
        return label
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .left
        return label
    }()

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
        let stack = UIStackView(arrangedSubviews: [titleLabel, ratingLabel])
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
        let stack = UIStackView(arrangedSubviews: [avatar, vStack, UIView()])
        stack.axis = .horizontal
        stack.alignment = .leading
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
}

extension CartCell {
    func configure(_ viewModel: ItemViewModel) {
        guard let priceFormatter else { preconditionFailure("cell was not set up properly") }

        titleLabel.text = viewModel.name
        let priceString = priceFormatter.string(from: .init(value: viewModel.price)) ?? ""
        priceLabel.text = "\(priceString) ETH"

        avatar.viewModel = .init(imageSize: .large, imageURL: viewModel.avatarUrl, likeButtonAction: nil)
    }
}
