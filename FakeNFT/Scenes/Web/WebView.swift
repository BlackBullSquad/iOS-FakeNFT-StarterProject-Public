import UIKit
import WebKit
import ProgressHUD

final class WebView: UIViewController, WKNavigationDelegate {
    private let url: URL

    private lazy var webView = WKWebView()

    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Lifecycle

extension WebView {
    override func viewDidLoad() {
        setupViews()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        webView.frame = view.bounds
    }
}

// MARK: - Initial Setup

private extension WebView {
    
    func setupViews() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance

        let backItem = UIBarButtonItem()
        backItem.title = nil
        backItem.tintColor = .asset(.main(.primary))
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem

        view.backgroundColor = .asset(.additional(.white))

        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true

        view.addSubview(webView)
    }
}
