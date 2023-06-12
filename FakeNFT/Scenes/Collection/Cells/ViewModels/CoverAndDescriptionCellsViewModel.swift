import Foundation

struct CoverAndDescriptionCellsViewModel {
    let collectionId: Int
    let cover: URL?
    let title: String
    let author: String
    let authorURL: URL?
    let description: String
    let nftsCount: Int

    let authorLinkTapped: ((URL) -> Void)

    init(_ model: Collection, authorLinkTapped: @escaping ((URL) -> Void)) {
        self.collectionId = model.id
        self.cover = model.cover
        self.title = model.name
        self.author = "Gul'dan"
        self.authorURL = URL(string: "https://practicum.yandex.ru")
        self.description = model.description
        self.nftsCount = model.nftCount
        self.authorLinkTapped = authorLinkTapped
    }
}
