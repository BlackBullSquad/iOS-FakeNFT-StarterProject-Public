import UIKit

final class CatalogueView: UIViewController {

    private let catalogueViewModel: CatalogueViewModel
    private let tableView = UITableView()

    private lazy var dataSource = makeDataSource()

    init(viewModel: CatalogueViewModel) {
        self.catalogueViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .asset(.additional(.white))
        setupTableView()
        setupNavBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        catalogueViewModel.updateListener = self
        catalogueViewModel.loadCollections()
    }

    private func setupTableView() {
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.register(CatalogueCell.self, forCellReuseIdentifier: CatalogueCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let guide = view.safeAreaLayoutGuide
        let hInset: CGFloat = 16

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
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
        
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: nil,
            action: nil)
        
        let sortButton: UIBarButtonItem = {
            let button = UIBarButtonItem()
            button.tintColor = .asset(.main(.primary))
            button.style = .plain
            button.image = UIImage(named: "sortIcon")
            button.target = self
            button.action = #selector(didTapSortButton)
            return button
        }()
        
        navigationController?.navigationBar.tintColor = .black
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

            cell.selectionStyle = .none
            cell.configure(title: viewModel.title, coverURL: viewModel.cover, nftCount: viewModel.nftsCount)
            return cell
        }
    }

    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CatalogueCellViewModel, CatalogueCellViewModel>()
        for collectionViewModel in catalogueViewModel.viewModels ?? [] {
            snapshot.appendSections([collectionViewModel])
            snapshot.appendItems([collectionViewModel], toSection: collectionViewModel)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { _ in
            self.catalogueViewModel.sortModels(.byName)
        }))
        alert.addAction(UIAlertAction(title: "По количеству NFT", style: .default, handler: { _ in
            self.catalogueViewModel.sortModels(.byNftCount)
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension CatalogueView: UITableViewDelegate {
    
    // MARK: Footer
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 21 }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { UIView() }
    
    // MARK: User Interaction
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCollectionID = catalogueViewModel.viewModels?[indexPath.section].collectionId else { return }
        catalogueViewModel.didSelectItem(at: selectedCollectionID)
    }
}

extension CatalogueView: CatalogueViewModelUpdateListener {
    func didUpdateCollections() {
        updateSnapshot()
    }

    func didFailWithError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to load data: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
