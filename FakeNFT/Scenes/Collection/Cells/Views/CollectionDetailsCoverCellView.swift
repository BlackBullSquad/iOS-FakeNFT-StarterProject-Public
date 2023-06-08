import UIKit
import Kingfisher

final class CollectionDetailsCoverCellView: UICollectionViewCell {
    
    static let identifier = "CoverCell"
    
    var viewModel: CollectionDetailsCellViewModel? {
        didSet {
            didUpdateViewModel()
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(coverImage)
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: 0.83),
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
    
    func configure(with viewModel: CollectionDetailsCellViewModel) {
        self.viewModel = viewModel
    }
}
