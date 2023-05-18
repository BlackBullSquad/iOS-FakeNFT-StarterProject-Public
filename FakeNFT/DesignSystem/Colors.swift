import UIKit

extension UIColor {
    
    enum Main: String {
        case backround, bg, green, lightGray, primary, red, whiteAlpha50
    }
    
    enum Additional: String {
        case blue, brown, gray, lightGreen, peach, white, yellow
    }
    
    static func appColor(_ asset: Main) -> UIColor {
        guard let color = UIColor(named: asset.rawValue) else { return .black }
        return color
    }
    
    static func appColor(_ asset: Additional) -> UIColor {
        guard let color = UIColor(named: asset.rawValue) else { return .black }
        return color
    }
    
}
