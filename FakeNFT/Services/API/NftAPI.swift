import Foundation

protocol NftAPI {
    // MARK: - Collections

    /// apiV1CollectionsCollectionIdGet
    /// Получение коллекции с заданным id
    /// - Parameter id Id of collection to get
    @discardableResult
    func getCollection(
        id: Int,
        onResponse: @escaping (Result<CollectionDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1CollectionsGet
    /// Получение списка коллекций
    @discardableResult
    func getCollections(
        onResponse: @escaping (Result<[CollectionDTO], Error>) -> Void
    ) -> NetworkTask?

    // MARK: - NFT

    /// apiV1NftNftIdGet
    /// Получение NFT с заданным Id
    /// - Parameter id Id of NFT to get
    @discardableResult
    func getNft(
        id: Int,
        onResponse: @escaping (Result<NftDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1NftGet
    /// Получение списка NFT
    @discardableResult
    func getNfts(
        onResponse: @escaping (Result<[NftDTO], Error>) -> Void
    ) -> NetworkTask?

    // MARK: - Order and Payment

    /// apiV1CurrenciesCurrencyIdGet
    /// Получение валюты с заданным id
    /// - Parameter id Id of currency to get
    @discardableResult
    func getCurrency(
        id: Int,
        onResponse: @escaping (Result<CurrencyDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1CurrenciesGet
    /// Получение списка валют
    @discardableResult
    func getCurrencies(
        onResponse: @escaping (Result<[CurrencyDTO], Error>) -> Void
    ) -> NetworkTask?

    /// apiV1Orders1Get
    /// Получение заказа
    /// - Parameter id Id of order to get
    @discardableResult
    func getOrder(
        id: Int,
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1Orders1PaymentCurrencyIdGet
    /// Оплата заказа валютой с заданным id
    /// - Parameter id Id of order для оплаты
    /// - Parameter currencyId Id валюты для оплаты
    @discardableResult
    func payOrder(
        id: Int,
        currencyId: Int,
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1Orders1Put
    /// Изменение заказа
    /// - Parameter id Id of order
    /// - Parameter nfts Содержание корзины
    @discardableResult
    func updateOrder(
        id: Int,
        nfts: [Int],
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask?

    // MARK: - Profile

    /// apiV1Profile1Get
    /// Получение профиля
    /// - Parameter id Id of profile
    @discardableResult
    func getProfile(
        id: Int,
        onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask?

    /// apiV1Profile1Put
    /// Обновление профиля
    /// - Parameter id Id of profile
    /// - Parameter name Имя
    /// - Parameter description Описание
    /// - Parameter website Сайт
    /// - Parameter likes список лайков
    @discardableResult
    func updateProfile( // swiftlint:disable:this function_parameter_count
        id: Int,
        name: String,
        description: String,
        website: URL,
        likes: [Int],
        onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask?

    // MARK: - Users

    /// apiV1UsersGet
    /// Получение списка пользователей
    @discardableResult
    func getUsers(
        onResponse: @escaping (Result<[UserDTO], Error>) -> Void
    ) -> NetworkTask?

    /// apiV1UsersUserIdGet
    /// Получение пользователя с заданным id
    /// - Parameter id Id пользователя
    @discardableResult
    func getUser(
        id: Int,
        onResponse: @escaping (Result<UserDTO, Error>) -> Void
    ) -> NetworkTask?
}

// MARK: - Defaults
extension NftAPI {
    /// apiV1Orders1Get
    /// Получение первого заказа
    @discardableResult
    func getOrder(
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask? {
        getOrder(id: 1, onResponse: onResponse)
    }

    /// apiV1Orders1PaymentCurrencyIdGet
    /// Оплата первого заказа валютой с заданным id
    /// - Parameter currencyId Id валюты для оплаты
    @discardableResult
    func payOrder(
        currencyId: Int,
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask? {
        payOrder(id: 1, currencyId: currencyId, onResponse: onResponse)
    }

    /// apiV1Orders1Put
    /// Изменение первого заказа
    /// - Parameter nfts Содержание корзины
    @discardableResult
    func updateOrder(
        nfts: [Int],
        onResponse: @escaping (Result<OrderDTO, Error>) -> Void
    ) -> NetworkTask? {
        updateOrder(id: 1, nfts: nfts, onResponse: onResponse)
    }

    /// apiV1Profile1Get
    /// Получение первого профиля
    @discardableResult
    func getProfile(
        onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask? {
        getProfile(id: 1, onResponse: onResponse)
    }

    /// apiV1Profile1Put
    /// Обновление первого профиля
    /// - Parameter name Имя
    /// - Parameter description Описание
    /// - Parameter website Сайт
    /// - Parameter likes список лайков
    @discardableResult
    func updateProfile(
        name: String,
        description: String,
        website: URL,
        likes: [Int],
        onResponse: @escaping (Result<ProfileDTO, Error>) -> Void
    ) -> NetworkTask? {
        updateProfile(
            id: 1,
            name: name,
            description: description,
            website: website,
            likes: likes,
            onResponse: onResponse
        )
    }
}
