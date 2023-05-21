import UIKit
import Kingfisher

final class NFTAvatarView: UIView {
    
    private let imageView = UIImageView()
    private let likeButton = UIButton()
    
    var viewModel: NFTAvatarViewModel? {
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
        viewModel?.likeButtonAction()
    }
}


// MARK: - Setup

extension NFTAvatarView {
    
    private func setupViews() {

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
    }
}

// MARK: - Configuration

extension NFTAvatarView {
    
    private func configure(with viewModel: NFTAvatarViewModel?) {
        
        guard let viewModel = viewModel else { return }
        
        let placeholder = UIImage(named: "placeholder")
        let processor = DownsamplingImageProcessor(size: CGSize(
            width: viewModel.imageSize.rawValue,
            height: viewModel.imageSize.rawValue))
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: viewModel.imageURL,
            placeholder: placeholder,
            options: [.processor(processor),
                      .scaleFactor(UIScreen.main.scale),
                      .transition(.fade(1))]
        )
        
        likeButton.tintColor = viewModel.isLiked ? .asset(.main(.red)) : .asset(.main(.primary))
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
}
