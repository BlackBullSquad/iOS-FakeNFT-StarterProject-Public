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
