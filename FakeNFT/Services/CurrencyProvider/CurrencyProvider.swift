protocol CurrencyProvider {
    func getCurrencies(handler: @escaping (Result<[Currency], Error>) -> Void)
}
