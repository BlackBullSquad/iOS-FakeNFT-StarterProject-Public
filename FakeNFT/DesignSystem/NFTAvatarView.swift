import UIKit
import Kingfisher

final class NftAvatarView: UIView {

    private let imageView = UIImageView()
    private let likeButton = UIButton()

    var viewModel: NftAvatarViewModel? {
        didSet {
            configure(with: viewModel)
        }
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    // MARK: - Actions

    @objc private func likeButtonTapped() {
        viewModel?.isLiked.toggle()
        viewModel?.likeButtonAction()
    }

    // MARK: - Reset to default

    private func reset() {
        imageView.image = nil
        likeButton.tintColor = .asset(.main(.primary))
        likeButton.setImage(UIImage(systemName: "hear.fill"), for: .normal)
    }

}

// MARK: - Setup

extension NftAvatarView {

    private func setupViews() {

        let radius = CGFloat(12)

        addSubview(imageView)
        addSubview(likeButton)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            likeButton.topAnchor.constraint(equalTo: imageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42)
        ])

        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)

        imageView.backgroundColor = .clear
        imageView.kf.indicatorType = .activity

        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}

// MARK: - Configuration

extension NftAvatarView {

    private func configure(with viewModel: NftAvatarViewModel?) {

        guard let viewModel = viewModel
        else {
            reset()
            return
        }

        let placeholder = UIImage(named: "placeholder")

        imageView.kf.setImage(with: viewModel.imageURL, placeholder: placeholder, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1))])

        likeButton.tintColor = viewModel.isLiked ? .asset(.main(.red)) : .asset(.additional(.white))
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
}
