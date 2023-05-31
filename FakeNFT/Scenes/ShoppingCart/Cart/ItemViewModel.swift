import Foundation

extension CartVC {
    struct ItemViewModel: Hashable {
        var name: String
        var price: Float
        var rating: Float
        var avatarUrl: URL?
    }
}
