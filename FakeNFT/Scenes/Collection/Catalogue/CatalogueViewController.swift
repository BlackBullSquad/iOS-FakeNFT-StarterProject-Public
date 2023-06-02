import UIKit

final class CatalogueViewController: UIViewController {

    private let collectionViewModels: CatalogueViewModel
    private let tableView = UITableView()

    private lazy var dataSource = makeDataSource()

    init(viewModel: CatalogueViewModel) {
        self.collectionViewModels = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionViewModels.updateListener = self
        collectionViewModels.loadCollections()
    }

    private func setupTableView() {
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(CatalogueCell.self, forCellReuseIdentifier: CatalogueCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let guide = view.safeAreaLayoutGuide
        let hInset: CGFloat = 16

        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.layer.masksToBounds = false
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -hInset)

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: hInset),
            tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -hInset),
            tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

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

    private func makeDataSource() -> UITableViewDiffableDataSource<CatalogueCellViewModel, CatalogueCellViewModel> {

        return .init(tableView: tableView) { tableView, indexPath, viewModel in

            guard
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: CatalogueCell.identifier,
                    for: indexPath
                ) as? CatalogueCell
            else {
                return UITableViewCell()
            }

            cell.configure(title: viewModel.title, coverURL: viewModel.cover, nftCount: viewModel.nftsCount)
            return cell
        }
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CatalogueCellViewModel, CatalogueCellViewModel>()
        for collectionViewModel in collectionViewModels.viewModels ?? [] {
            snapshot.appendSections([collectionViewModel])
            snapshot.appendItems([collectionViewModel], toSection: collectionViewModel)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { _ in
            self.collectionViewModels.sortModels(.byName)
        }))
        alert.addAction(UIAlertAction(title: "По количеству NFT", style: .default, handler: { _ in
            self.collectionViewModels.sortModels(.byNftCount)
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension CatalogueViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 21 }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { UIView() }
}

extension CatalogueViewController: CatalogueViewModelUpdateListener {
    func didUpdateCollections() {
        updateSnapshot()
    }

    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to load data: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
