import Foundation

struct FakeNftAPI {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = Self.defaultNetworkClient) {
        self.networkClient = networkClient
    }

    static var defaultNetworkClient: NetworkClient {
        let decoder = JSONDecoder()

        let formatter1 = ISO8601DateFormatter()
        formatter1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let formatter2 = ISO8601DateFormatter()
        formatter2.formatOptions = [.withInternetDateTime]

        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            let date = formatter1.date(from: dateStr) ?? formatter2.date(from: dateStr)

            guard let date else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateStr)")
            }

            return date
        }

        return DefaultNetworkClient(decoder: decoder)
    }
}

extension FakeNftAPI: NftAPI {
    func updateProfile(id: Int,
                       name: String,
                       description: String,
                       website: URL,
                       likes: [Int],
                       onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.updateProfile(
                id: id,
                name: name,
                description: description,
                website: website,
                likes: likes
            ).request,
            type: ProfileDTO.self,
            onResponse: onResponse
        )
    }

    func getProfile(
        id: Int,
        onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getProfile(id: id).request,
            type: ProfileDTO.self,
            onResponse: onResponse
        )
    }

    func updateOrder(id: Int, nfts: [Int], onResponse: @escaping (Result<OrderDTO, Error>) -> Void) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.updateOrder(id: id, nfts: nfts).request,
            type: OrderDTO.self,
            onResponse: onResponse
        )
    }

    func payOrder(
        id: Int,
        currencyId: Int,
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.payOrder(id: id, currencyId: currencyId).request,
            type: OrderDTO.self,
            onResponse: onResponse
        )
    }

    func getOrder(
        id: Int,
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getOrder(id: id).request,
            type: OrderDTO.self,
            onResponse: onResponse
        )
    }

    func getCollection(
        id: Int,
        onResponse: @escaping (Result<CollectionDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getCollection(id: id).request,
            type: CollectionDTO.self,
            onResponse: onResponse
        )
    }

    func getCollections(
        onResponse: @escaping (Result<[CollectionDTO], Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getCollections.request,
            type: [CollectionDTO].self,
            onResponse: onResponse
        )
    }

    func getNft(
        id: Int,
        onResponse: @escaping (Result<NftDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getNft(id: id).request,
            type: NftDTO.self,
            onResponse: onResponse
        )
    }

    func getNfts(
        onResponse: @escaping (Result<[NftDTO], Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getNfts.request,
            type: [NftDTO].self,
            onResponse: onResponse
        )
    }

    func getCurrency(
        id: Int,
        onResponse: @escaping (Result<CurrencyDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getCurrency(id: id).request,
            type: CurrencyDTO.self,
            onResponse: onResponse
        )
    }

    func getCurrencies(
        onResponse: @escaping (Result<[CurrencyDTO], Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getCurrencies.request,
            type: [CurrencyDTO].self,
            onResponse: onResponse
        )
    }

    func getUsers(
        onResponse: @escaping (Result<[UserDTO], Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getUsers.request,
            type: [UserDTO].self,
            onResponse: onResponse
        )
    }

    func getUser(
        id: Int,
        onResponse: @escaping (Result<UserDTO, Error>) -> Void
    ) -> NetworkTask? {
        networkClient.send(
            request: FakeAPIRequest.getUser(id: id).request,
            type: UserDTO.self,
            onResponse: onResponse
        )
    }
}
