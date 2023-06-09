import Foundation

struct Nft: Identifiable {
    let id: Int
    let name: String
    let description: String
    let rating: Int
    let images: [URL?]
    let price: Float
}
