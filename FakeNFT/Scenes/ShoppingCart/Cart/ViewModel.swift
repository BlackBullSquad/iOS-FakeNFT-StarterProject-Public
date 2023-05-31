extension CartVC {
    struct ViewModel: Hashable {
        var items: [CartCell.ItemViewModel] = []
        var sortedBy: SortOrder = .byName

        var nftCount: Int { items.count }
        var totalPrice: Float { items.map(\.price).reduce(0, +) }

        var sortedItems: [CartCell.ItemViewModel] {
            switch sortedBy {
            case .byPrice:
                return items.sorted { $0.price < $1.price }
            case .byRating:
                return items.sorted { $0.rating < $1.rating }
            case .byName:
                return items.sorted { $0.name < $1.name }
            }
        }
    }

    enum SortOrder: Hashable {
        case byPrice
        case byRating
        case byName
    }
}
