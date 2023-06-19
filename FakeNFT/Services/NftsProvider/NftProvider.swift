protocol NftProvider {
    func getNfts(_ ids: Set<Nft.ID>, handler: @escaping (Result<[Nft], Error>) -> Void)
}
