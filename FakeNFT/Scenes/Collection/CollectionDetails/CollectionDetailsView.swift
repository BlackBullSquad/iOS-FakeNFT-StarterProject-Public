import UIKit
import Kingfisher

private enum Section: Int {
    case cover = 0
    case description
    case collection
}

final class CollectionDetailsView: UIViewController {
    
    private let collectionViewModel: CollectionDetailsViewModel
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    init(viewModel: CollectionDetailsViewModel) {
        self.collectionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.additional(.white))
        collectionViewModel.loadCollection(with: collectionViewModel.collectionID) { [weak self] in
            DispatchQueue.main.async {
                self?.setupUI()
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        
        // MARK: - Layout Element Properties
        
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
        
        lazy var text: UILabel = {
            let label = UILabel()
            label.font = .asset(.regular13)
            label.textColor = .asset(.main(.primary))
            label.textAlignment = .natural
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        // MARK: - Stacks
        
        lazy var hStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [authorLabel, authorLinkLabel])
            stack.axis = .horizontal
            stack.spacing = 4
            stack.alignment = .center
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        lazy var vStackInside: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, hStack])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .leading
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        lazy var vStackMain: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [vStackInside, text])
            stack.axis = .vertical
            stack.spacing = 0
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
    
        // MARK: - Collection View Setup
        
        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(
            CollectionDetailsCoverCellView.self,
            forCellWithReuseIdentifier: CollectionDetailsCoverCellView.identifier
        )
        collectionView.register(
            CollectionDetailsDescriptionCellView.self,
            forCellWithReuseIdentifier: CollectionDetailsDescriptionCellView.identifier
        )
        collectionView.register(
            CollectionDetailsNftListCellView.self,
            forCellWithReuseIdentifier: CollectionDetailsNftListCellView.identifier
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - Layout constraints
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // MARK: - Filling interface elements with data
        
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
    
    // MARK: -  UICollectionView layout setup
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = Section(rawValue: sectionIndex) else {
                fatalError("Invalid section")
            }
            
            let inset: CGFloat = 16
            
            switch sectionType {
        
            // Collection cover image
            case .cover:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.83)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: itemSize,
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
            
            // Collection text description
            case .description:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: itemSize,
                    subitem: item,
                    count: 1
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: inset,
                    leading: inset,
                    bottom: 21,
                    trailing: inset
                )
                
                return section
                
            // Collection NFT list
            case .collection:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .estimated(192)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(192)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                group.interItemSpacing = .fixed(10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: inset,
                    bottom: 0,
                    trailing: inset
                )
                section.interGroupSpacing = 28
                
                return section
            }
        }
        
        return layout
    }
}

// MARK: - Delegate

extension CollectionDetailsView: UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let sectionType = Section(rawValue: section) else {
            fatalError("Invalid section")
        }
        
        switch sectionType {
        case .cover: return 1
        case .description: return 1
        case .collection: return collectionViewModel.viewModel?.nftsCount ?? 0
        }
    }
}

// MARK: - Data Source

extension CollectionDetailsView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let sectionType = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section")
        }
        
        switch sectionType {
        case .cover:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionDetailsCoverCellView.identifier,
                for: indexPath
            )
            if
                let coverCell = cell as? CollectionDetailsCoverCellView,
                let item = collectionViewModel.viewModel {
                coverCell.configure(with: item)
            }
            return cell
            
        case .description:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionDetailsDescriptionCellView.identifier,
                for: indexPath
            )
            if
                let descriptionCell = cell as? CollectionDetailsDescriptionCellView,
                let item = collectionViewModel.viewModel {
                descriptionCell.configure(with: item)
            }
            return cell
            
        case .collection:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionDetailsNftListCellView.identifier,
                for: indexPath
            )
            if
                let collectionCell = cell as? CollectionDetailsNftListCellView,
                let item = collectionViewModel.viewModel?.nfts[indexPath.item] {
                collectionCell.configure(with: item)
            }
            return cell
        }
    }
}
