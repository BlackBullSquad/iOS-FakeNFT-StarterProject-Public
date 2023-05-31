import UIKit

final class CatalogueVC: UIViewController {
    
    let dataService = CollectionProvider(api: FakeNftAPI())
    let tableView = UITableView()
    
    private lazy var dataSource = makeDataSource()
    
    private var viewModels: [ViewModel]? = nil {
        didSet {
            updateSnapshot()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataService.getCollections { result in
            switch result {
            case .success(let collections):
                DispatchQueue.main.async { [weak self] in
                    self?.viewModels = collections.map { ViewModel($0) }
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func setupTableView() {
            tableView.dataSource = dataSource
            tableView.delegate = self
            tableView.register(CatalogueCell.self, forCellReuseIdentifier: CatalogueCell.identifier)
            view.addSubview(tableView)
            tableView.translatesAutoresizingMaskIntoConstraints = false

            let guide = view.safeAreaLayoutGuide
            let hInset: CGFloat = 16
            
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
            tableView.layer.masksToBounds = false
            tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -hInset)

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 21),
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
    
    private func makeDataSource() -> UITableViewDiffableDataSource<ViewModel, ViewModel> {
        return UITableViewDiffableDataSource<ViewModel, ViewModel>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, viewModel: ViewModel) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogueCell.identifier, for: indexPath) as? CatalogueCell else {
                return UITableViewCell()
            }
        
            cell.configure(title: viewModel.title, coverURL: viewModel.cover, nftCount: viewModel.nftsCount)
            return cell
        }
    }
    
    private func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ViewModel, ViewModel>()
        for viewModel in viewModels ?? [] {
            snapshot.appendSections([viewModel])
            snapshot.appendItems([viewModel], toSection: viewModel)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    @objc func didTapSortButton() {
        let alert = UIAlertController(title: "Сортировать", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "По названию", style: .default, handler: { _ in
            self.viewModels?.sort { $0.title < $1.title }
        }))
        alert.addAction(UIAlertAction(title: "По количеству NFT", style: .default, handler: { _ in
            self.viewModels?.sort { $0.nftsCount > $1.nftsCount }
        }))
        alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension CatalogueVC {
    struct ViewModel: Hashable {
        let collectionId: Int
        let title: String
        let cover: URL?
        let nftsCount: Int
        
        init(_ model: Collection) {
            self.collectionId = model.id
            self.title = model.name
            self.cover = model.cover
            self.nftsCount = model.nftCount
        }
    }
}

extension CatalogueVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 21
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
