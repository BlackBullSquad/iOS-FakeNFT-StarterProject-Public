import Foundation

// MARK: - Errors

enum ApplicationError: Error {
    case networkError(NetworkError)
    case dataError(DataError)
}

enum NetworkError: Error {
    case requestFailed
}

enum DataError: Error {
    case invalidData
    case decodingError
    case collectionNotFound
}

// MARK: - Provider

final class CollectionProvider {
    let api: NftAPI
    
    init(api: NftAPI) {
        self.api = api
    }
    
    func getCollections(handler: @escaping (Result<Collections, ApplicationError>) -> Void) {
        api.getNfts { [weak self] result in
            switch result {
            case .success(let nftsData):
                self?.api.getCollections { result  in
                    switch result {
                    case .success(let collectionData):
                        let nfts = nftsData.compactMap(Nft.init)
                        let collections = collectionData.compactMap { Collection($0, nfts: nfts) }
                        handler(.success(collections))
                    case .failure(let error):
                        print("Failed to fetch collectionData: \(error)")
                        handler(.failure(.networkError(.requestFailed)))
                    }
                }
            case .failure(let error):
                print("Failed to fetch nftsData: \(error)")
                handler(.failure(.networkError(.requestFailed)))
            }
        }
    }
    
    func getCollection(_ id: Int, handler: @escaping (Result<Collection, ApplicationError>) -> Void) {
        getCollections { result in
            switch result {
            case .success(let collections):
                if let collection = collections.filter( { $0.id == id } ).first {
                    handler(.success(collection))
                } else {
                    handler(.failure(.dataError(.invalidData)))
                }
            case .failure(let error):
                switch error {
                case .networkError(let networkError):
                    print("Failed to fetch collections: \(networkError)")
                    handler(.failure(.networkError(.requestFailed)))
                case .dataError(let dataError):
                    print("Failed to fetch collections: \(dataError)")
                    handler(.failure(.dataError(.decodingError)))
                }
            }
        }
    }
}

// MARK: - Converters

private extension Nft {
    init?(_ dto: NftDTO) {
        guard let id = Int(dto.id) else { return nil }
        let imageUrls = dto.images.compactMap { URL(string: $0.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") }

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

private extension Collection {
    init?(_ dto: CollectionDTO, nfts: [Nft]) {
        guard let id = Int(dto.id) else { return nil }
        
        let nfts = nfts.filter { dto.nfts.contains($0.id) }
        
        self.init(
            id: id,
            name: dto.name,
            description: dto.description,
            cover: URL(string: dto.cover.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
            nfts: nfts
        )
    }
}
