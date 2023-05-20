import UIKit

enum Asset {
    case main(Main)
    case additional(Additional)

    var assetName: String {
        switch self {
        case let .main(asset):
            return asset.rawValue
        case let .additional(asset):
            return asset.rawValue
        }
    }
}

enum Main: String {
    case backround, bg, green, lightGray, primary, red, whiteAlpha50
}

enum Additional: String {
    case blue, brown, gray, lightGreen, peach, white, yellow
}

extension UIColor {
    static func asset(_ asset: Asset) -> UIColor {
        guard let color = UIColor(named: asset.assetName) else { return .black }
        return color
    }
}
