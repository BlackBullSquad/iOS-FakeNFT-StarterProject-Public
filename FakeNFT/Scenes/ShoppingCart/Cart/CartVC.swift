import UIKit

final class CartVC: UIViewController {
    var deps: Dependencies
    var viewModel: ViewModel = .init()

    init(deps: Dependencies) {
        self.deps = deps
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension CartVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Корзина"
    }

}
