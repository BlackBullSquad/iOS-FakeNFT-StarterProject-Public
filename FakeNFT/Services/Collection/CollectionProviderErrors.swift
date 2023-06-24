import Foundation

enum CollectionProviderError: Error {
    case network(NetworkError)
    case data(DataError)

    enum NetworkError: Error {
        case requestFailed
    }

    enum DataError: Error {
        case invalidData
        case decodingError
        case collectionNotFound
    }
}

enum ApplicationError: Error {
    case networkError(NetworkError)
    case dataError(DataError)
}

enum NetworkError: Error {
    case requestFailed
    case updateError
}

enum DataError: Error {
    case invalidData
    case decodingError
    case collectionNotFound
    case updateProfileError
}
