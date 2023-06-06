import Foundation

struct CollectionCellViewModel {
    let collectionId: Int
    let cover: URL?
    let title: String
    let author: String
    let authorURL: URL?
    let description: String
    let nfts: [NftCellViewModel]
    let nftsCount: Int

    init(_ model: Collection) {
        self.collectionId = model.id
        self.cover = model.cover
        self.title = model.name
        self.author = "Gul'dan"
        self.authorURL = URL(string: "https://practicum.yandex.ru")
        self.description = model.description
        self.nfts = model.nfts.map { NftCellViewModel($0) }
        self.nftsCount = model.nftCount
    }
}

struct NftCellViewModel {
    let id: Int
    let imageURL: URL?
    let rating: Int
    let name: String
    let price: String

    init(_ model: Nft) {
        self.id = model.id
        self.rating = model.rating
        self.imageURL = model.images.first ?? nil
        self.name = model.name
        self.price = String(model.price)
    }
}
