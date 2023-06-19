struct NftListViewModel {
    let nftCellViewModels: [NftCellViewModel]

    init(
        nfts: [Nft],
        fetchedLikes: [Int],
        shoppingCart: ShoppingCart,
        updateLikesAction: @escaping ([Int]) -> Void
    ) {
        var likes = fetchedLikes
        self.nftCellViewModels = nfts.map { nft in
            let isLiked = likes.contains(nft.id)
            return NftCellViewModel(
                nft,
                isLiked: isLiked,
                shoppingCartService: shoppingCart,
                didUpdateLike: { id in
                    if likes.contains(id) {
                        likes.removeAll(where: { $0 == id })
                    } else {
                        likes.append(id)
                    }
                    updateLikesAction(likes)
                }
            )
        }
    }
}
