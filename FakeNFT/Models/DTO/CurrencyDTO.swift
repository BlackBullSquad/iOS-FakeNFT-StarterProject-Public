import Foundation

struct CurrencyDTO {
    let id: String

    let name: String
    let title: String

    let image: URL
}

extension CurrencyDTO: Decodable {}
