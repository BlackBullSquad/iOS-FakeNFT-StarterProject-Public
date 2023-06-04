import UIKit
import Combine

final class CurrencySelectView: UIViewController {
    let viewModel: CurrencySelectViewModel
    var cancellable: AnyCancellable?

    private lazy var dataSource = makeDataSource()

    init(_ viewModel: CurrencySelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cancellable = viewModel.bind { [weak self] in self?.viewModelUpdate() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Components

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var infoText: UIStackView = {
        let firstLine = UILabel()
        firstLine.text = "Совершая покупку, вы соглашаетесь с условиями"
        firstLine.textColor = .asset(.main(.primary))
        firstLine.font = .asset(.regular13)
        firstLine.textAlignment = .left

        let secondLine = UILabel()
        secondLine.text = "Пользовательского соглашения"
        secondLine.textColor = .asset(.additional(.blue))
        secondLine.font = .asset(.regular13)
        secondLine.textAlignment = .left

        let vStack = UIStackView(arrangedSubviews: [firstLine, secondLine])
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 4
        vStack.translatesAutoresizingMaskIntoConstraints = false

        return vStack
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .currencySelectView
        )

        collection.keyboardDismissMode = .onDrag
        collection.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)

        collection.register(CurrencySelectCellView.self,
                            forCellWithReuseIdentifier: "\(CurrencySelectCellView.self)")

        collection.alwaysBounceVertical = true

        collection.delegate = self

        return collection
    }()
}

// MARK: - Lifecycle

extension CurrencySelectView {
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = dataSource
        setupViews()
        viewModel.start()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }

    func viewModelUpdate() {
        purchaseButton.layer.opacity = viewModel.isPurchaseAvailable ? 1 : 0.5
        purchaseButton.isEnabled = viewModel.isPurchaseAvailable
        applySnapshot()
    }
}

// MARK: - Setup

extension CurrencySelectView {
    func setupViews() {
        title = "Выберите способ оплаты"
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .black

        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        view.backgroundColor = .white

        let guide = view.safeAreaLayoutGuide

        view.addSubview(collectionView)
        view.addSubview(infoText)
        view.addSubview(purchaseButton)

        NSLayoutConstraint.activate([
            infoText.bottomAnchor.constraint(equalTo: purchaseButton.topAnchor, constant: -20),
            infoText.trailingAnchor.constraint(equalTo: purchaseButton.trailingAnchor),
            infoText.leadingAnchor.constraint(equalTo: purchaseButton.leadingAnchor),
            purchaseButton.heightAnchor.constraint(equalToConstant: 60),
            purchaseButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
            purchaseButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
            purchaseButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - DataSource

private extension CurrencySelectView {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, CurrencySelectCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, CurrencySelectCellViewModel>

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, viewModel in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "\(CurrencySelectCellView.self)",
                    for: indexPath
                ) as? CurrencySelectCellView

                cell?.viewModel = viewModel

                return cell
            }
        )

        return dataSource
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.items, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Actions

extension CurrencySelectView: UICollectionViewDelegate {
    @objc func didTapPurchaseButton() {
        viewModel.purchase()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedItem(indexPath.row)
    }
}
