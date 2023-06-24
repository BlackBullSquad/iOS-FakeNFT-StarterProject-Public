import Foundation

struct CoverCellViewModel {
    let collectionId: Int
    let cover: URL?

    init(_ model: Collection) {
        self.collectionId = model.id
        self.cover = model.cover
    }
}
