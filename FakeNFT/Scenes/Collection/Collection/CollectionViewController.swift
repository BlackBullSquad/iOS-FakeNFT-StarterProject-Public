import UIKit

final class CollectionViewController: UIViewController {
    
    private let collectionViewModel: CollectionViewModel
    //private let collectionView = UICollectionView()
    
    
    init(viewModel: CollectionViewModel) {
        self.collectionViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    
}

