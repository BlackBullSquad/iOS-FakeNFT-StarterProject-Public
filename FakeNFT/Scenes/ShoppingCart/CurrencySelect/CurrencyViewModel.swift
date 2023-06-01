import Foundation

extension CurrencySelectCell {
    struct ViewModel: Hashable {
        let name: String
        let code: String
        let currencyImage: URL

        init(_ model: Currency) {
            name = model.name
            code = model.code
            currencyImage = model.image
        }
    }
}
