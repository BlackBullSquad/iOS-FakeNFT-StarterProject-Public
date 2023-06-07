import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkRequest {
    var endpoint: URL?
    var queryParameters: [String: String]?
    var payload: Encodable?
    var httpMethod: HttpMethod = .get
}
