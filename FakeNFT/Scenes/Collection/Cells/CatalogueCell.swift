import UIKit
import Kingfisher

final class CatalogueCell: UITableViewCell {
    
    static let identifier = "CatalogueCell"
    
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
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            coverImage, titleLabel
        ])
        stack.axis = .vertical
        stack.spacing = 4
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
            coverImage.heightAnchor.constraint(equalToConstant: 140),

            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension CatalogueCell {
    
    func configure(title: String, coverURL imageURL: URL?, nftCount: Int) {
        titleLabel.text = "\(title) (\(nftCount))"

        let placeholder = UIImage(named: "placeholder")
        
        coverImage.kf.setImage(with: imageURL, placeholder: placeholder, options: [.scaleFactor(UIScreen.main.scale), .transition(.fade(1))])
    }
}
