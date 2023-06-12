import Foundation

struct NftListViewModel {
    let nfts: [NftCellViewModel]
    
    init(nfts: [Nft], shoppingCart: ShoppingCart) {
        self.nfts = nfts.map { NftCellViewModel($0, shoppingCartService: shoppingCart) }
    }
}
