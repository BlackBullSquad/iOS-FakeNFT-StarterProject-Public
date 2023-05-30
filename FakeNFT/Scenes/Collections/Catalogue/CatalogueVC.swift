import UIKit

final class CatalogueVC: UIViewController {
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        setupNavBar()
    }
    
    
    private func setup() {
        
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
}
