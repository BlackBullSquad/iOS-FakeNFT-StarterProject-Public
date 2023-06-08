import UIKit
import Combine

final class CurrencySelectView: UIViewController {
    private let viewModel: CurrencySelectViewModel
    private var cancellable: AnyCancellable?

    private lazy var dataSource = makeDataSource()

    init(_ viewModel: CurrencySelectViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cancellable = viewModel.bind { [weak self] in self?.viewModelDidUpdate() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.asset(.white), for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .asset(.black)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private lazy var infoText: UITextView = {
        let textView = UITextView()

        let url = URL(string: "https://fake.url.com")!
        let attributedString = NSMutableAttributedString(
            string: "Совершая покупку, вы соглашаетесь с условиями "
        )
        attributedString.append(.init(string: "Пользовательского соглашения",
                                      attributes: [.link: url]))

        textView.attributedText = attributedString
        textView.linkTextAttributes = [.foregroundColor: UIColor.asset(.blueUniversal)]
        textView.textColor = .asset(.black)
        textView.font = .asset(.regular13)

        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.delegate = self

        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(
            frame: .zero,
            collectionViewLayout: .currencySelectView
        )

        collection.keyboardDismissMode = .onDrag
        collection.contentInset = .init(top: 20, left: 0, bottom: 150, right: 0)

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.active()
    }

    private func viewModelDidUpdate() {
        purchaseButton.layer.opacity = viewModel.isPurchaseAvailable ? 1 : 0.5
        purchaseButton.isEnabled = viewModel.isPurchaseAvailable

        applySnapshot()

        switch viewModel.destination {

        case .none:
            break

        case let .errorLoading(viewModel):
            showErrorDialog(viewModel)

        case let .webInfo(url):
            pushUrlView(url)

        }
    }
}

// MARK: - Initial Setup

private extension CurrencySelectView {
    func setupViews() {
        title = "Выберите способ оплаты"
        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .asset(.black)

        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
        view.backgroundColor = .asset(.white)

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

// MARK: - User Actions

extension CurrencySelectView: UICollectionViewDelegate, UITextViewDelegate {
    @objc private func didTapPurchaseButton() {
        viewModel.purchase()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectedItem(indexPath.row)
    }

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction
    ) -> Bool {
        viewModel.openTermsAndConditions()
        return false
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

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()

        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.items, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

// MARK: - Destination

private extension CurrencySelectView {
    func showErrorDialog(_ viewModel: StatusViewModel) {
        let statusView = StatusView(viewModel)
        statusView.modalPresentationStyle = .fullScreen

        present(statusView, animated: true)
    }

    func pushUrlView(_ viewModel: URL) {
        let webView = WebView(url: viewModel)

        navigationController?.pushViewController(webView, animated: true)
    }
}
