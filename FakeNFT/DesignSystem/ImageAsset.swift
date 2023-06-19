import UIKit

enum ImageAsset: String {
    case placeholder, deleteFromCart, sortIcon, ratingStar
    case statusSuccess, statusFailure
}

extension UIImage {
    static func asset(_ asset: ImageAsset) -> UIImage {
        guard let image = UIImage(named: asset.rawValue) else { return .remove }
        return image
    }
}
