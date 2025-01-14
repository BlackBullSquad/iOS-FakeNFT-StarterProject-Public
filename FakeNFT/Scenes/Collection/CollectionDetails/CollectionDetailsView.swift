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
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: CollectionViewLayoutFactory.createLayout()
        )
        return collectionView
    }()

    // MARK: - Layout Element Properties

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

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold22)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular13)
        label.textAlignment = .natural
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLinkLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.additional(.blue))
        label.font = .asset(.regular15)
        label.textAlignment = .natural
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var text: UILabel = {
        let label = UILabel()
        label.font = .asset(.regular13)
        label.textColor = .asset(.main(.primary))
        label.textAlignment = .natural
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Initializers

    init(viewModel: CollectionDetailsViewModel) {
        self.collectionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.additional(.white))
        collectionViewModel.didLoadCollection(with: collectionViewModel.collectionID) { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.collectionViewModel.errorMessage {
                    self?.didFailWithError(errorMessage)
                } else {
                    self?.initializeUserInterface()
                    self?.collectionView.reloadData()
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Setup UI

    private func initializeUserInterface() {
        initializeStackViewElements()
        initializeCollectionView()
        fillInterfaceElementsWithData()
    }

    // Stacks

    private func initializeStackViewElements() {
        let hStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [authorLabel, authorLinkLabel])
            stack.axis = .horizontal
            stack.spacing = 4
            stack.alignment = .center
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        let vStackInside: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [titleLabel, hStack])
            stack.axis = .vertical
            stack.spacing = 8
            stack.alignment = .leading
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        let _: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [vStackInside, text])
            stack.axis = .vertical
            stack.spacing = 0
            stack.distribution = .fill
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
    }

    // Collection View Setup

    private func initializeCollectionView() {

        collectionView.backgroundColor = .clear
        collectionView.contentInsetAdjustmentBehavior = .never

        collectionView.register(
            CoverCellView.self,
            forCellWithReuseIdentifier: CoverCellView.identifier
        )
        collectionView.register(
            DescriptionCellView.self,
            forCellWithReuseIdentifier: DescriptionCellView.identifier
        )
        collectionView.register(
            NftListView.self,
            forCellWithReuseIdentifier: NftListView.identifier
        )

        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        // Layout constraints
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func fillInterfaceElementsWithData() {
        // Filling interface elements with data
        titleLabel.text = collectionViewModel.descriptionCellViewModel?.title
        authorLabel.text = "Автор коллекции"
        authorLinkLabel.text = collectionViewModel.descriptionCellViewModel?.author
        text.text = collectionViewModel.descriptionCellViewModel?.description

        let placeholder = UIImage(named: "placeholder")
        let imageURL = collectionViewModel.coverCellViewModel?.cover
        coverImage.kf.setImage(
            with: imageURL,
            placeholder: placeholder,
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1))
            ]
        )
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
        case .cover: return collectionViewModel.coverCellViewModel == nil ? 0 : 1
        case .description: return collectionViewModel.descriptionCellViewModel == nil ? 0 : 1
        case .collection: return collectionViewModel.nftListViewModel?.nftCellViewModels.count ?? 0
        }
    }
}

// MARK: - Data Source

extension CollectionDetailsView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let sectionType = Section(rawValue: indexPath.section) else {
            fatalError("Invalid section")
        }

        switch sectionType {
        case .cover:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CoverCellView.identifier,
                for: indexPath
            )
            if
                let coverCell = cell as? CoverCellView,
                let item = collectionViewModel.coverCellViewModel {
                coverCell.configure(with: item)

                coverCell.onBackButtonTap = { [weak self] in
                    guard let self = self else { return }
                    self.collectionViewModel.coordinator?.goBack()
                }
            }
            return cell

        case .description:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DescriptionCellView.identifier,
                for: indexPath
            )
            if
                let descriptionCell = cell as? DescriptionCellView,
                let item = collectionViewModel.descriptionCellViewModel {
                descriptionCell.configure(with: item)
            }
            return cell

        case .collection:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NftListView.identifier,
                for: indexPath
            )
            if
                let collectionCell = cell as? NftListView,
                let nftListViewModel = collectionViewModel.nftListViewModel {
                    let item = nftListViewModel.nftCellViewModels[indexPath.item]
                    collectionCell.configure(with: item)
                }
            return cell
        }
    }
}

// MARK: - Error Alert

extension CollectionDetailsView {
    func didFailWithError(_ error: Error) {
        let alertController = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async { [weak self] in
            self?.present(alertController, animated: true)
        }
    }
}
