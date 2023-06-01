import UIKit

final class ShoppingCartController: UIViewController {
    var deps: Dependencies
    var onPurchase: () -> Void

    var viewModel: ViewModel = .init() { didSet { refreshView() } }
    private lazy var dataSource = makeDataSource()

    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""
        return formatter
    }()

    init(deps: Dependencies, onPurchase: @escaping () -> Void) {
        self.deps = deps
        self.onPurchase = onPurchase
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    let tableView = UITableView()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.regular15)
        label.textAlignment = .left
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.main(.green))
        label.font = .asset(.bold17)
        label.textAlignment = .left
        return label
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textColor = .asset(.main(.primary))
        label.font = .asset(.bold17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapPurchaseButton), for: .touchUpInside)
        return button
    }()

    private lazy var buttonPanel: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [countLabel, priceLabel])
        vStack.axis = .vertical
        vStack.spacing = 2

        let panel = UIStackView(arrangedSubviews: [vStack, purchaseButton])
        panel.axis = .horizontal
        panel.spacing = 12

        panel.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        panel.isLayoutMarginsRelativeArrangement = true

        panel.backgroundColor = .asset(.main(.lightGray))
        panel.layer.cornerRadius = 12
        panel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        panel.layer.masksToBounds = true

        panel.translatesAutoresizingMaskIntoConstraints = false

        return panel
    }()}

// MARK: - DataSource

private extension ShoppingCartController {
    typealias DataSource = UITableViewDiffableDataSource<Int, ShoppingCartCell.ItemViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, ShoppingCartCell.ItemViewModel>

    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, _ in
            guard
                let self,
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ShoppingCartCell.identifier, for: indexPath
                ) as? ShoppingCartCell else {
                return UITableViewCell()
            }

            cell.priceFormatter = self.priceFormatter
            let viewModel = self.viewModel.sortedItems[indexPath.row]
            cell.configure(viewModel) { [weak self] in
                self?.deleteFromCart(viewModel)
            }

            return cell
        }
    }

    func updateSnapshot() {
        var snapshot = SnapShot()

        snapshot.appendSections([0])
        for itemViewModel in viewModel.sortedItems {
            snapshot.appendItems([itemViewModel], toSection: 0)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - Setup

private extension ShoppingCartController {
    private func setupNavBar() {
        let sortButton: UIBarButtonItem = {
            let button = UIBarButtonItem()
            button.tintColor = .asset(.main(.primary))
            button.style = .plain
            button.image = UIImage(named: "sortIcon")
            button.target = self
            button.action = #selector(didTapSortButton)
            return button
        }()

        navigationItem.rightBarButtonItem = sortButton
    }

    func setupComponents() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        tableView.dataSource = dataSource
        tableView.register(ShoppingCartCell.self, forCellReuseIdentifier: ShoppingCartCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)

        let guide = view.safeAreaLayoutGuide
        let hInset: CGFloat = 16

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.layer.masksToBounds = false
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -hInset)

        view.addSubview(tableView)
        view.addSubview(buttonPanel)
        view.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 21),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: hInset),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -hInset),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            buttonPanel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            buttonPanel.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            purchaseButton.widthAnchor.constraint(equalToConstant: 240)
        ])
    }
}

// MARK: - Lifecycle

extension ShoppingCartController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
        setupNavBar()
        refreshView()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshViewModel()
    }

    func refreshViewModel() {
        reloadExternalData()
    }

    func refreshView() {
        let priceString = priceFormatter.string(from: .init(value: viewModel.totalPrice)) ?? ""

        priceLabel.text = "\(priceString) ETH"
        countLabel.text = "\(viewModel.nftCount) NFT"
        emptyLabel.isHidden = viewModel.nftCount > 0
        buttonPanel.isHidden = viewModel.nftCount == 0

        updateSnapshot()
    }
}

// MARK: - Actions

extension ShoppingCartController {
    @objc func didTapPurchaseButton() {
        onPurchase()
    }

    @objc func didTapSortButton() {
        let alert = UIAlertController(
            title: "Сортировка",
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(
            UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
                self?.viewModel.sortedBy = .byPrice
            }
        )

        alert.addAction(
            UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
                self?.viewModel.sortedBy = .byRating
            }
        )

        alert.addAction(
            UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
                self?.viewModel.sortedBy = .byName
            }
        )

        alert.addAction(
            UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        )

        present(alert, animated: true)
    }

    func deleteFromCart(_ model: ShoppingCartCell.ItemViewModel) {
        let deleteController = DeleteController(avatarURL: model.avatarUrl!) { [weak self] in
            guard let self else { return }
            deps.shoppingCart.removeFromCart(model.id)
            reloadExternalData()
        }
        deleteController.modalPresentationStyle = .overFullScreen

        present(deleteController, animated: true)
    }
}

// MARK: - External data

private extension ShoppingCartController {
    func updateItems(_ items: [ShoppingCartCell.ItemViewModel]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewModel.items = items
        }
    }

    func reloadExternalData() {
        let ids = deps.shoppingCart.nfts
        deps.nftProvider.getNfts(Set(ids)) { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(data):
                updateItems(data.map(ShoppingCartCell.ItemViewModel.init))
            case let .failure(error):
                print(error)
            }
        }
    }
}
