import UIKit
import Combine

final class ShoppingCartView: UIViewController {
    private let viewModel: ShoppingCartViewModel
    private var cancellable: AnyCancellable?

    private lazy var dataSource = makeDataSource()

    init(_ viewModel: ShoppingCartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        cancellable = viewModel.bind { [weak self] in self?.viewModelDidUpdate() }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Components

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .asset(.white)
        return tableView
    }()

    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.black)
        label.font = .asset(.regular15)
        label.textAlignment = .natural
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .asset(.greenUniversal)
        label.font = .asset(.bold17)
        label.textAlignment = .natural
        return label
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Корзина пуста"
        label.textColor = .asset(.black)
        label.font = .asset(.bold17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var purchaseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.setTitleColor(.asset(.white), for: .normal)
        button.titleLabel?.font = .asset(.bold17)
        button.backgroundColor = .asset(.black)
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

        panel.backgroundColor = .asset(.lightGrey)
        panel.layer.cornerRadius = 12
        panel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        panel.layer.masksToBounds = true

        panel.translatesAutoresizingMaskIntoConstraints = false

        return panel
    }()

    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.tintColor = .asset(.black)
        button.style = .plain
        button.image = .asset(.sortIcon)
        button.target = self
        button.action = #selector(didTapSortButton)
        return button
    }()
}

// MARK: - Lifecycle

extension ShoppingCartView {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refresh()
    }

    private func viewModelDidUpdate() {
        navigationItem.rightBarButtonItem = !viewModel.isCartEmpty ? sortButton : nil

        priceLabel.text = viewModel.priceLabel
        countLabel.text = viewModel.countLabel

        emptyLabel.isHidden = !viewModel.isCartEmpty
        buttonPanel.isHidden = viewModel.isCartEmpty

        if viewModel.isLoading {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }

        updateSnapshot()

        switch viewModel.destination {
        case .none:
            break

        case .selectingSort:
            showSortingDialog()

        case let .deleteItem(itemViewModel):
            showDeleteRequest(itemViewModel)

        case let .errorLoading(viewModel):
            showErrorDialog(viewModel)

        }
    }
}

// MARK: - Initial Setup

private extension ShoppingCartView {
    func setupViews() {
        navigationItem.rightBarButtonItem = sortButton

        view.backgroundColor = .asset(.white)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 140

        tableView.dataSource = dataSource
        tableView.register(ShoppingCartCellView.self,
                           forCellReuseIdentifier: "\(ShoppingCartCellView.self)")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = .init(top: 20, left: 0, bottom: 80, right: 0)

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
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: hInset),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -hInset),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonPanel.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            buttonPanel.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            buttonPanel.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            purchaseButton.heightAnchor.constraint(equalToConstant: 44),
            priceLabel.widthAnchor.constraint(equalToConstant: 88)
        ])
    }
}

// MARK: - User Actions

private extension ShoppingCartView {
    @objc func didTapPurchaseButton() {
        viewModel.purchase()
    }

    @objc func didTapSortButton() {
        viewModel.requestSorting()
    }
}

// MARK: - DataSource

private extension ShoppingCartView {
    typealias DataSource = UITableViewDiffableDataSource<Int, ShoppingCartCellViewModel>
    typealias SnapShot = NSDiffableDataSourceSnapshot<Int, ShoppingCartCellViewModel>

    func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, _ in
            guard
                let self,
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: "\(ShoppingCartCellView.self)", for: indexPath
                ) as? ShoppingCartCellView else {
                return UITableViewCell()
            }

            cell.viewModel = self.viewModel.sortedItems[indexPath.row]

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

// MARK: - Destination

private extension ShoppingCartView {
    func showSortingDialog() {
        let alert = UIAlertController(title: "Сортировка",
                                      message: nil,
                                      preferredStyle: .actionSheet)

        SortingOrder.allCases.forEach { orderType in
            alert.addAction(
                UIAlertAction(title: orderType.rawValue, style: .default) { [weak self] _ in
                    self?.viewModel.selectSorting(by: orderType)
                }
            )
        }

        alert.addAction(
            UIAlertAction(title: "Закрыть", style: .cancel) { [weak self] _ in
                self?.viewModel.cancelSorting()
            }
        )

        present(alert, animated: true)
    }

    func showDeleteRequest(_ itemModel: NftDeleteViewModel) {
        let deleteController = NftDeleteView(itemModel)
        deleteController.modalPresentationStyle = .overFullScreen

        present(deleteController, animated: true)
    }

    func showErrorDialog(_ viewModel: StatusViewModel) {
        let statusView = StatusView(viewModel)
        statusView.modalPresentationStyle = .fullScreen

        present(statusView, animated: true)
    }
}
