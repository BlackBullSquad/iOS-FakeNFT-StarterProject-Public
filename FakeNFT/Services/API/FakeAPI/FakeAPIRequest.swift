import Foundation

enum FakeAPIRequest {
    case getCollections
    case getCollection(id: Int)

    case getNfts
    case getNft(id: Int)

    case getCurrency(id: Int)
    case getCurrencies

    case getOrder(id: Int)
    case payOrder(id: Int, currencyId: Int)
    case updateOrder(id: Int, nfts: [Int])

    case getProfile(id: Int)
    case updateProfile(id: Int, name: String, description: String, website: URL, likes: [Int])

    case getUsers
    case getUser(id: Int)
}

 extension FakeAPIRequest {
    var request: NetworkRequest {
        .init(endpoint: URL(string: urlString),
                       queryParameters: nil,
                       payload: requestPayload,
                       httpMethod: requestMethod)
    }
 }

private extension FakeAPIRequest {
    var urlString: String {
        let baseURLString = "https://64411f3a792fe886a89efa72.mockapi.io"

        switch self {
        case .getCollections:
            return baseURLString + "/api/v1/collections"
        case let .getCollection(id):
            return baseURLString + "/api/v1/collections/\(id)"
        case .getNfts:
            return baseURLString + "/api/v1/nft"
        case let .getNft(id):
            return baseURLString + "/api/v1/nft/\(id)"
        case let .getCurrency(id):
            return baseURLString + "/api/v1/currencies/\(id)"
        case .getCurrencies:
            return baseURLString + "/api/v1/currencies"
        case let .getOrder(id):
            return baseURLString + "/api/v1/orders/\(id)"
        case let .payOrder(id, currencyId):
            return baseURLString + "/api/v1/orders/\(id)/payment/\(currencyId)"
        case let .updateOrder(id, _):
            return baseURLString + "/api/v1/orders/\(id)"
        case let .getProfile(id):
            return baseURLString + "/api/v1/profile/\(id)"
        case let .updateProfile(id, _, _, _, _):
            return baseURLString + "/api/v1/profile/\(id)"
        case .getUsers:
            return baseURLString + "/api/v1/users"
        case let .getUser(id):
            return baseURLString + "/api/v1/users/\(id)"
        }
    }
}

extension FakeAPIRequest {
    var requestMethod: HttpMethod {
        switch self {
        case .updateOrder, .updateProfile:
            return .put
        default:
            return .get
        }
    }
}

extension FakeAPIRequest {
    var requestPayload: Encodable? {
        switch self {
        case let .updateOrder(_, nfts):
            return UpdateOrderDTO(nfts: nfts)

        case let .updateProfile(_, name, description, website, likes):
            return UpdateProfileDTO(name: name,
                                    description: description,
                                    website: website,
                                    likes: likes)

        default:
            return nil
        }
    }
}

// extension FakeAPIRequest {
//    func getNetworkRequest<Payload: Encodable>() -> NetworkRequest<Payload> {
//        switch self {
//        case let .updateOrder(_, nfts):
//            let payload = UpdateOrderDTO(nfts: nfts)
//
//            return NetworkRequest<Payload>(endpoint: URL(string: urlString),
//                                                  queryParameters: nil,
//                                                  payload: payload,
//                                                  httpMethod: requestMethod)
//
//        case let .updateProfile(_, name, description, website, likes):
//            let payload =  UpdateProfileDTO(name: name,
//                                            description: description,
//                                            website: website,
//                                            likes: likes)
//
//            return NetworkRequest<Payload>(endpoint: URL(string: urlString),
//                                                    queryParameters: nil,
//                                                    payload: payload,
//                                                    httpMethod: requestMethod)
//
//        default:
//            return NetworkRequest(endpoint: URL(string: urlString),
//                                  queryParameters: nil,
//                                  httpMethod: requestMethod)
//        }
//    }
// }

//        NetworkRequest(endpoint: URL(string: urlString),
//                       queryParameters: nil,
//                       payload: requestPayload,
//                       httpMethod: requestMethod)
