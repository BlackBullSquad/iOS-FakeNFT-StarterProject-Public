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

extension FakeAPIRequest: NetworkRequest {
    var endpoint: URL? { URL(string: urlString) }
    var queryParameters: [String: String]? { requestParameters }
    var httpMethod: HttpMethod { requestMethod }
}

extension FakeAPIRequest {
    static let baseURLString = "https://64411f3a792fe886a89efa72.mockapi.io"

    var urlString: String {
        switch self {
        case .getCollections:
            return Self.baseURLString + "/api/v1/collections"
        case let .getCollection(id):
            return Self.baseURLString + "/api/v1/collections/\(id)"
        case .getNfts:
            return Self.baseURLString + "/api/v1/nft"
        case let .getNft(id):
            return Self.baseURLString + "/api/v1/nft/\(id)"
        case let .getCurrency(id):
            return Self.baseURLString + "/api/v1/currencies/\(id)"
        case .getCurrencies:
            return Self.baseURLString + "/api/v1/currencies"
        case let .getOrder(id):
            return Self.baseURLString + "/api/v1/orders/\(id)"
        case let .payOrder(id, currencyId):
            return Self.baseURLString + "/api/v1/orders/\(id)/payment/\(currencyId)"
        case let .updateOrder(id, _):
            return Self.baseURLString + "/api/v1/orders/\(id)"
        case let .getProfile(id):
            return Self.baseURLString + "/api/v1/profile/\(id)"
        case let .updateProfile(id, _, _, _, _):
            return Self.baseURLString + "/api/v1/profile/\(id)"
        case .getUsers:
            return Self.baseURLString + "/api/v1/users"
        case let .getUser(id):
            return Self.baseURLString + "/api/v1/users/\(id)"
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
    var requestParameters: [String: String]? {
        switch self {
        case let .updateOrder(_, nfts):
            return ["nfts": nfts.map(String.init).joined(separator: ",")]
        case let .updateProfile(_, name, description, website, likes):
            return [
                "name": name,
                "description": description,
                "website": website.absoluteString,
                "likes": likes.map(String.init).joined(separator: ",")
            ]
        default:
            return nil
        }
    }
}
