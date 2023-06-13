import Foundation

protocol NftLikesProviderProtocol {
    func getLikes(userID: Int, completion: @escaping (Result<[Int], ApplicationError>) -> Void)
    func updateLikes(userID: Int, likes: [Nft.ID], completion: @escaping (Result<Void, ApplicationError>) -> Void)
}

final class NftLikesProvider {
    
    let api: NftAPI

    init(api: NftAPI) {
        self.api = api
    }
    
    func getLikes(userID: Int, completion: @escaping (Result<[Int], ApplicationError>) -> Void) {
        api.getProfile(id: userID) { result in

            switch result {
            case .success(let profile):
                completion(.success(profile.likes))
            case.failure(let error):
                print("Failed to fetch likes: \(error)")
                completion(.failure(.networkError(.requestFailed)))
            }
        }
    }
    
    func updateLikes(userID: Int, likes: [Int], completion: @escaping (Result<Void, ApplicationError>) -> Void) {
        api.getProfile(id: userID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                self.api.updateProfile(
                    id: userID,
                    name: profile.name,
                    description: profile.description,
                    website: profile.website,
                    likes: likes
                ) { result in
                    switch result {
                    case .success(_):
                        completion(.success(()))
                    case .failure(let error):
                        print("Failed to update likes: \(error)")
                        completion(.failure(.networkError(.updateError)))
                    }
                }
            case .failure(let error):
                print("Failed to fetch profile for updating likes: \(error)")
                completion(.failure(.networkError(.updateError)))
            }
        }
    }
}

extension NftLikesProvider: NftLikesProviderProtocol {}
