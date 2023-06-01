import UIKit
import Kingfisher

final class CurrencySelectCell: UICollectionViewCell {
    static let identifier = "CurrencySelectCell"

    // MARK: - Components

    private lazy var currencyImage = UIImageView()
    private lazy var currencyImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .left
        return label
    }()

    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.green))
        label.font = .asset(.regular13)
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupSubviews() {
        currencyImage.backgroundColor = .clear
        currencyImage.kf.indicatorType = .activity

        contentView.backgroundColor = .asset(.main(.lightGray))
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true

        let vStack = UIStackView(arrangedSubviews: [nameLabel, codeLabel])
        vStack.axis = .vertical
        vStack.spacing = 0

        let hStack = UIStackView(arrangedSubviews: [currencyImage, vStack, UIView()])
        hStack.axis = .horizontal
        hStack.spacing = 4
        hStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(currencyImageBackground)
        contentView.addSubview(hStack)

        NSLayoutConstraint.activate([
            currencyImage.widthAnchor.constraint(equalTo: currencyImage.heightAnchor),
            currencyImageBackground.widthAnchor.constraint(equalTo: currencyImageBackground.heightAnchor),
            currencyImageBackground.widthAnchor.constraint(equalTo: currencyImage.heightAnchor),
            currencyImageBackground.centerXAnchor.constraint(equalTo: currencyImage.centerXAnchor),
            currencyImageBackground.centerYAnchor.constraint(equalTo: currencyImage.centerYAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - Configuration

extension CurrencySelectCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(nil)
    }

    func configure(_ viewModel: ViewModel?) {
        let placeholder = UIImage(named: "placeholder")

        guard let viewModel else {
            nameLabel.text = ""
            codeLabel.text = ""
            currencyImage.image = nil

            return
        }

        nameLabel.text = viewModel.name
        codeLabel.text = viewModel.code

        currencyImage.kf.setImage(
            with: viewModel.currencyImage,
            placeholder: placeholder,
            options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1))]
        )
    }
}
