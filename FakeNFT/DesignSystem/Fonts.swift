import UIKit

/// Пример использования: let font = TextStyle.bold17.apply
enum TextStyle {
    case medium10
    case bold22
    case bold17
    case regular13
    case regular15
    case regular17
    case bold34
    case bold32
    
    var apply: UIFont {
        switch self {
        case .medium10: return .systemFont(ofSize: 10, weight: .medium)
        case .bold22: return .boldSystemFont(ofSize: 22)
        case .bold17: return .boldSystemFont(ofSize: 17)
        case .regular13: return .systemFont(ofSize: 13)
        case .regular15: return .systemFont(ofSize: 15)
        case .regular17: return .systemFont(ofSize: 17)
        case .bold34: return .boldSystemFont(ofSize: 34)
        case .bold32:return.boldSystemFont(ofSize: 32)
        }
    }
}
