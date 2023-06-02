import Foundation

struct CatalogueCellViewModel: Hashable {
    let collectionId: Int
    let title: String
    let cover: URL?
    let nftsCount: Int

    init(_ model: Collection) {
        self.collectionId = model.id
        self.title = model.name
        self.cover = model.cover
        self.nftsCount = model.nftCount
    }
}
