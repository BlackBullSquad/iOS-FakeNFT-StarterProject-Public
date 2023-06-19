import Foundation

final class FakeCurrencyProvider {
    let api: NftAPI

    init(api: NftAPI) {
        self.api = api
    }
}

extension FakeCurrencyProvider: CurrencyProvider {
    func getCurrencies(handler: @escaping (Result<[Currency], Error>) -> Void) {
        api.getCurrencies { result in
            switch result {
            case let .success(dtos):
                let currencies = dtos.compactMap(Currency.init)
                handler(.success(currencies))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
}

private extension Currency {
    init?(_ dto: CurrencyDTO) {
        guard
            let id = Int(dto.id),
            let imageUrlString = dto.image.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ),
            let imageUrl = URL(string: imageUrlString)
        else { return nil }

        self.init(id: id, code: dto.title, name: dto.name, image: imageUrl)
    }
}
