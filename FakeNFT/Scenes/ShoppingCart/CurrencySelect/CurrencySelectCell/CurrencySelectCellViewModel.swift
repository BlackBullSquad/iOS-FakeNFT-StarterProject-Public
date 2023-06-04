import Foundation

struct CurrencySelectCellViewModel: Hashable, Identifiable {
    let id: Int
    let name: String
    let code: String
    let currencyImage: URL
    let isSelected: Bool

    init(_ model: Currency, isSelected: Bool) {
        id = model.id
        name = model.name
        code = model.code
        currencyImage = model.image
        self.isSelected = isSelected
    }
}
