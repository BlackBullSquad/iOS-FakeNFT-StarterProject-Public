import Foundation
import ProgressHUD

protocol LoadingHUDServiceProtocol: AnyObject {
    func showLoading()
    func hideLoading()
}

final class LoadingHUDService: LoadingHUDServiceProtocol {

    static let shared = LoadingHUDService()

    private init() {}

    func showLoading() {
        DispatchQueue.main.async {
            ProgressHUD.show()
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
}
