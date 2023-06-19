import Foundation

final class FakeNftProvider {
    let api: NftAPI

    init(api: NftAPI) {
        self.api = api
    }
}

extension FakeNftProvider: NftProvider {
    func getNfts(_ ids: Set<Nft.ID>, handler: @escaping (Result<[Nft], Error>) -> Void) {
        api.getNfts { result in
            switch result {
            case let .success(dtos):
                let nfts = dtos.compactMap(Nft.init)
                let filteredNfts = nfts.filter { ids.contains($0.id) }
                handler(.success(filteredNfts))
            case let .failure(error):
                handler(.failure(error))
            }
        }
    }
}

private extension Nft {
    init?(_ dto: NftDTO) {
        guard let id = Int(dto.id) else { return nil }
        let imageUrls = dto.images.compactMap { urlString -> URL? in
            guard let encodedUrlString = urlString.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) else { return nil }

            return URL(string: encodedUrlString)
        }

        self.init(
            id: id,
            name: dto.name,
            description: dto.description,
            rating: dto.rating,
            images: imageUrls,
            price: dto.price
        )
    }
}
