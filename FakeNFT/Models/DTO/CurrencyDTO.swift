struct CurrencyDTO {
    let id: String

    let name: String
    let title: String

    let image: String
}

extension CurrencyDTO: Decodable {}
