extension CartVC {
    struct ViewModel {
        var nftCount: String = ""
        var totalPrice: String = ""
        var items: [ItemViewModel] = []
        var sortedBy: SortOrder = .byName
    }

    enum SortOrder: String {
        case byPrice = "По цене"
        case byRating = "По рейтингу"
        case byName = "По названию"
    }
}
