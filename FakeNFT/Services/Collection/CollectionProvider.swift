import Foundation

protocol CollectionProviderProtocol {
    func getCollections(completion: @escaping (Result<Collections, ApplicationError>) -> Void)
    func getCollection(id: Int, completion: @escaping (Result<Collection, ApplicationError>) -> Void)
}

// MARK: - Provider

final class CollectionProvider {
    let api: NftAPI

    init(api: NftAPI) {
        self.api = api
    }

    // MARK: - Public methods

    func getCollections(completion: @escaping (Result<Collections, ApplicationError>) -> Void) {
        api.getNfts { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nftsData):
                self.handleNftData(nftsData, completion: completion)
            case .failure(let error):
                LogService.shared.log("Failed to fetch nftsData: \(error)", level: .error)
                completion(.failure(.networkError(.requestFailed)))
            }
        }
    }

    func getCollection(id: Int, completion: @escaping (Result<Collection, ApplicationError>) -> Void) {
        getCollections { [weak self] result in
            guard let self = self else { return }
            self.handleCollectionsResult(result, for: id, completion: completion)
        }
    }

    // MARK: - Private methods

    private func handleNftData(_ nftsData: [NftDTO], completion: @escaping (Result<Collections, ApplicationError>) -> Void) {
        api.getCollections { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let collectionData):
                self.processSuccessfulResponse(nftsData: nftsData, collectionData: collectionData, completion: completion)
            case .failure(let error):
                LogService.shared.log("Failed to fetch collectionData: \(error)", level: .error)
                completion(.failure(.networkError(.requestFailed)))
            }
        }
    }

    private func processSuccessfulResponse(nftsData: [NftDTO], collectionData: [CollectionDTO], completion: (Result<Collections, ApplicationError>) -> Void) {
        let nfts = nftsData.compactMap(Nft.init)
        let collections = collectionData.compactMap { Collection($0, nfts: nfts) }
        completion(.success(collections))
    }

    private func handleCollectionsResult(
        _ result: Result<Collections, ApplicationError>,
        for id: Int,
        completion: @escaping (Result<Collection, ApplicationError>) -> Void
    ) {
        switch result {
        case .success(let collections):
            handleCollectionsSuccess(collections, for: id, completion: completion)
        case .failure(let error):
            handleCollectionFailure(error, completion: completion)
        }
    }

    private func handleCollectionsSuccess(_ collections: Collections, for id: Int, completion: (Result<Collection, ApplicationError>) -> Void) {
        if let collection = collections.filter({ $0.id == id }).first {
            completion(.success(collection))
        } else {
            completion(.failure(.dataError(.invalidData)))
        }
    }

    private func handleCollectionFailure(_ error: ApplicationError, completion: (Result<Collection, ApplicationError>) -> Void) {
        switch error {
        case .networkError(let networkError):
            LogService.shared.log("Failed to fetch collections: \(networkError)", level: .error)
            completion(.failure(.networkError(.requestFailed)))
        case .dataError(let dataError):
            LogService.shared.log("Failed to fetch collections: \(dataError)", level: .error)
            completion(.failure(.dataError(.decodingError)))
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

extension CollectionProvider: CollectionProviderProtocol { }
