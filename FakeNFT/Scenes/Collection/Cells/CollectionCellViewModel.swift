import Foundation

struct CollectionCellViewModel {
    let collectionId: Int
    let cover: URL?
    let title: String
    let author: String
    let description: String
    let nfts: [Nft]

    init(_ model: Collection) {
        self.collectionId = model.id
        self.cover = model.cover
        self.title = model.name
        self.author = "Gul'dan"
        self.description = model.description
        self.nfts = model.nfts
    }
}
