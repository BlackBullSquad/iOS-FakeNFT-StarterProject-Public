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

enum ColorAsset: String {
    case backgroundUniversal = "kitBackgroundUniversal"
    case black = "kitBlack"
    case blackUniversal = "kitBlackUniversal"
    case blueUniversal = "kitBlueUniversal"
    case greenUniversal = "kitGreenUniversal"
    case greyUniversal = "kitGreyUniversal"
    case lightGrey = "kitLightGrey"
    case redUniversal = "kitRedUniversal"
    case white = "kitWhite"
    case whiteUniversal = "kitWhiteUniversal"
    case yellowUniversal = "kitYellowUniversal"
}

enum Main: String {
    case background, bg, green, lightGray, primary, red, whiteAlpha50 // swiftlint:disable:this identifier_name
}

enum Additional: String {
    case blue, brown, gray, lightGreen, peach, white, yellow
}

extension UIColor {
    static func asset(_ asset: Asset) -> UIColor {
        guard let color = UIColor(named: asset.assetName) else { return .black }
        return color
    }

    static func asset(_ asset: ColorAsset) -> UIColor {
        guard let color = UIColor(named: asset.rawValue) else { return .systemPink }
        return color
    }
}
