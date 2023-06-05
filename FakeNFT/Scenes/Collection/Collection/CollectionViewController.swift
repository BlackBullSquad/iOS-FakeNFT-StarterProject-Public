import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {
    
    private let collectionViewModel: CollectionViewModel
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        return collectionView
    }()
    
    init(viewModel: CollectionViewModel) {
        self.collectionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionViewModel.loadCollection(with: collectionViewModel.collectionID) {
            self.setupUI()
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    private func setupUI() {
        
        lazy var coverImage: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            imageView.layer.cornerRadius = 12
            imageView.clipsToBounds = true
            imageView.kf.indicatorType = .activity
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .asset(.main(.primary))
            label.font = .asset(.bold22)
            label.textAlignment = .natural
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        lazy var authorLabel: UILabel = {
            let label = UILabel()
            label.textColor = .asset(.main(.primary))
            label.font = .asset(.regular13)
            label.textAlignment = .natural
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        lazy var authorLinkLabel: UILabel = {
            let label = UILabel()
            label.textColor = .asset(.additional(.blue))
            label.font = .asset(.regular15)
            label.textAlignment = .natural
            label.isUserInteractionEnabled = true
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        lazy var text: UITextView = {
            let text = UITextView()
            text.font = .asset(.regular13)
            text.textColor = .asset(.main(.primary))
            text.textAlignment = .natural
            text.textContainerInset = .zero
            text.textContainer.lineFragmentPadding = 0
            text.translatesAutoresizingMaskIntoConstraints = false
            return text
        }()
        
        lazy var hStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                authorLabel, authorLinkLabel
            ])
            stack.axis = .horizontal
            stack.spacing = 4
            stack.alignment = .center
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        lazy var vStackInside: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                titleLabel, hStack
            ])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .leading
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        lazy var vStackMain: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                vStackInside, text
            ])
            stack.axis = .vertical
            stack.spacing = 0
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        view.addSubview(coverImage)
        view.addSubview(vStackMain)
        
        let guide = view.safeAreaLayoutGuide
        let inset: CGFloat = 16
        
        NSLayoutConstraint.activate([
            coverImage.topAnchor.constraint(equalTo: view.topAnchor),
            coverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImage.heightAnchor.constraint(equalTo: coverImage.widthAnchor, multiplier: 0.83),
            
            vStackMain.topAnchor.constraint(equalTo: coverImage.bottomAnchor, constant: inset),
            vStackMain.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: inset),
            vStackMain.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -inset),
            vStackMain.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20)
        ])
        
        titleLabel.text = collectionViewModel.viewModel?.title
        authorLabel.text = "Автор коллекции"
        authorLinkLabel.text = collectionViewModel.viewModel?.author
        text.text = collectionViewModel.viewModel?.description
        
        let placeholder = UIImage(named: "placeholder")
        let imageURL = collectionViewModel.viewModel?.cover
        coverImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1))
            ]
        )

    }
    
    
    private func createLayout() -> UICollectionViewLayout {
        
        return .init()
        
    }
    
}

