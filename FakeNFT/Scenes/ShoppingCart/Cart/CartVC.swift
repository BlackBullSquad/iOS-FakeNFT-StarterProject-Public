import UIKit

final class CartVC: UIViewController {
    var deps: Dependencies
    var viewModel: ViewModel = .init() { didSet { refreshView() } }

    let tableView = UITableView()
    private lazy var dataSource = makeDataSource()

    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.decimalSeparator = ","
        formatter.groupingSeparator = ""
        return formatter
    }()

    init(deps: Dependencies) {
        self.deps = deps
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource

private extension CartVC {
    typealias DataSource = UITableViewDiffableDataSource<Int, CartCell.ItemViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, CartCell.ItemViewModel>

    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, _ in
            guard
                let self,
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CartCell.identifier, for: indexPath
                ) as? CartCell else {
                return UITableViewCell()
            }

            cell.priceFormatter = self.priceFormatter
            let viewModel = self.viewModel.sortedItems[indexPath.row]
            cell.configure(viewModel) { [weak self] in
                self?.deleteFromCart(viewModel.id)
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

private extension CartVC {
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

    func setupTableView() {
        tableView.dataSource = dataSource
        tableView.register(CartCell.self, forCellReuseIdentifier: CartCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let guide = view.safeAreaLayoutGuide
        let hInset: CGFloat = 16

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.layer.masksToBounds = false
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -hInset)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 21),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: hInset),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -hInset),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
}

// MARK: - Lifecycle

extension CartVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        updateSnapshot()
    }
}

// MARK: - Actions

extension CartVC {
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

    func deleteFromCart(_ id: Nft.ID) {
        deps.shoppingCart.removeFromCart(id)
        reloadExternalData()
    }
}

// MARK: - External data

private extension CartVC {
    func updateItems(_ items: [CartCell.ItemViewModel]) {
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
                updateItems(data.map(CartCell.ItemViewModel.init))
            case let .failure(error):
                print(error)
            }
        }
    }
}
