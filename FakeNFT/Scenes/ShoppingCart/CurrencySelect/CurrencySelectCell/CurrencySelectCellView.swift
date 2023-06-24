import UIKit
import Kingfisher

final class CurrencySelectCellView: UICollectionViewCell {
    var viewModel: CurrencySelectCellViewModel? { didSet { viewModelDidUpdate() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var currencyImage = UIImageView()

    private lazy var currencyImageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .asset(.black)
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        return label
    }()

    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.greenUniversal)
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        return label
    }()
}

// MARK: - Lifecycle

extension CurrencySelectCellView {
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }

    private func viewModelDidUpdate() {
        guard let viewModel else { return }

        let placeholder = UIImage.asset(.placeholder)

        nameLabel.text = viewModel.name
        codeLabel.text = viewModel.code
        contentView.layer.borderWidth = viewModel.isSelected ? 1 : 0

        currencyImage.kf.setImage(
            with: viewModel.currencyImage,
            placeholder: placeholder,
            options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1))]
        )
    }

    private func resetView() {
        nameLabel.text = nil
        codeLabel.text = nil
        contentView.layer.borderWidth = 0
        currencyImage.image = nil
    }
}

// MARK: - Initial Setup

private extension CurrencySelectCellView {
    func setupSubviews() {
        currencyImage.backgroundColor = .clear
        currencyImage.kf.indicatorType = .activity

        contentView.backgroundColor = .asset(.lightGrey)
        contentView.layer.borderColor = UIColor.asset(.black).cgColor
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
