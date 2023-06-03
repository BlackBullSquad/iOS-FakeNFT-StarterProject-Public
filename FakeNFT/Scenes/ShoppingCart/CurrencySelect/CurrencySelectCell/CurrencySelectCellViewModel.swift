import Foundation

struct CurrencySelectCellViewModel: Hashable {
    let name: String
    let code: String
    let currencyImage: URL
    let isSelected: Bool

    init(_ model: Currency, isSelected: Bool) {
        name = model.name
        code = model.code
        currencyImage = model.image
        self.isSelected = isSelected
    }
}
