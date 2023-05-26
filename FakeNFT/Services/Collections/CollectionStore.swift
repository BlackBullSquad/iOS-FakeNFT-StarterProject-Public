import Foundation

protocol CollectionServiceProtocol {
    func fetchCatalogueViewModels(completion: @escaping (Result<[CatalogueViewModel], Error>) -> Void)
}

final class CollectionStore {
    
    private let api: NftAPI
    
    init(api: NftAPI) {
        self.api = api
    }
    
    private func convertToModel(from dto: CollectionDTO) -> CollectionModel? {
        guard let id = Int(dto.id) else { return nil }
        let createdAt = dto.createdAt
        let name = dto.name
        let description = dto.description
        let nfts = dto.nfts
        let cover = dto.cover
        return .init(id: id, createdAt: createdAt, name: name, description: description, nfts: nfts, cover: cover)
    }
}

extension CollectionStore: CollectionServiceProtocol {
    func fetchCatalogueViewModels(completion: @escaping (Result<[CatalogueViewModel], Error>) -> Void) {
        api.getCollections { [weak self] result in
            switch result {
            case .success(let dtos):
                let models = dtos.compactMap { self?.convertToModel(from: $0) }
                let viewModels = models.compactMap { self?.convertToCatalogueViewModel(from: $0) }
                completion(.success(viewModels))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func convertToCatalogueViewModel(from model: CollectionModel) -> CatalogueViewModel? {
        let id = model.id
        let name = model.name
        let nftsCount = model.nfts.count
        let cover = model.cover
        return .init(id: id, name: name, nftsCount: nftsCount, cover: cover)
    }
}
