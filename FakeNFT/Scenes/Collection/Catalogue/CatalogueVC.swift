import UIKit

final class CatalogueVC: UIViewController {
    
    let dataService = CollectionProvider(api: FakeNftAPI())
    let tableView = UITableView()
    
    private var viewModels: [ViewModel]? = nil {
        didSet {
            displayCollections()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dataService.getCollections { result in
            switch result {
            case .success(let collections):
                DispatchQueue.main.async { [weak self] in
                    self?.viewModels = collections.map { ViewModel($0) }
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
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
            return button
        }()
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    func displayCollections() {
        viewModels?.forEach { collection in
            print(collection)
        }
    }
}

private extension CatalogueVC {
    struct ViewModel {
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

extension CatalogueVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CatalogueCell.identifier, for: indexPath) as? CatalogueCell else {
            return UITableViewCell()
        }
        
        guard let viewModels = viewModels else { return .init() }
        
        let data = viewModels[indexPath.section]
       
        cell.configure(title: data.title, coverURL: data.cover, nftCount: data.nftsCount)
       
        return cell
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
