import UIKit
import Kingfisher

final class CoverCellView: UICollectionViewCell {

    static let identifier = "CoverCell"

    var viewModel: CoverCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }

    var onBackButtonTap: (() -> Void)?

    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .asset(.main(.primary))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(coverImage)
        contentView.addSubview(backButton)

        let buttonSize: CGFloat = 24

        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: 0.83),

            backButton.widthAnchor.constraint(equalToConstant: buttonSize),
            backButton.heightAnchor.constraint(equalToConstant: buttonSize),
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 9)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func didUpdateViewModel() {
        let placeholder = UIImage(named: "placeholder")
        let imageURL = viewModel?.cover
        coverImage.kf.setImage(with: imageURL,
                               placeholder: placeholder,
                               options: [.scaleFactor(UIScreen.main.scale),
                                         .transition(.fade(1))]
        )
    }

    @objc private func didTapBackButton() {
        onBackButtonTap?()
    }

    func configure(with viewModel: CoverCellViewModel) {
        self.viewModel = viewModel
    }
}
