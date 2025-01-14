import UIKit
import Kingfisher

final class CatalogueCellView: UITableViewCell {

    static let identifier = "CatalogueCell"

    // MARK: - Layout Element Properties

    // Constants

    private let stackSpacingHalf: CGFloat = 4

    // Properties

    private lazy var coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .natural
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Stack

    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [coverImage, titleLabel])
        stack.axis = .vertical
        stack.spacing = stackSpacingHalf
        stack.backgroundColor = .asset(.additional(.white))
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
        contentView.addSubview(vStack)

        NSLayoutConstraint.activate([
            coverImage.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            coverImage.heightAnchor.constraint(equalToConstant: 140),

            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    // MARK: - Reuse Preparation

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        coverImage.kf.cancelDownloadTask()
        coverImage.image = nil
    }
}

extension CatalogueCellView {

    func configure(title: String, coverURL imageURL: URL?, nftCount: Int) {
        titleLabel.text = "\(title) (\(nftCount))"

        let placeholder = UIImage(named: "placeholder")

        coverImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [.scaleFactor(UIScreen.main.scale),
                      .transition(.fade(1))]) { result in
                          ImageCacheService.shared.checkCacheStatus(
                            for: result
                          )
                      }
    }
}
