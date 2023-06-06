//
//  ProfilleService.swift
//  FakeNFT
//
//  Created by MacBook on 03.06.2023.
//

import Foundation

protocol ProfileService: Any {
    func getUser(completion: @escaping (Result<Profile, Error>) -> Void)
    func getMyNFT(with profile: Profile, completion: @escaping (Result<[NFT], Error>) -> Void)
    func getFavoritesNFT(completion: @escaping (Result<[NFT], Error>) -> Void)
}

final class ProfileServiceImpl: ProfileService {
    
    // MARK: - Properties
    private let nftApi: NftAPI
    
    // MARK: - Initialiser
    init(nftApi: NftAPI) {
        self.nftApi = nftApi
    }
    
    // MARK: - Methods
    func getUser(completion: @escaping (Result<Profile, Error>) -> Void) {
        nftApi.getProfile { result in
            switch result {
            case .success(let profileDTO):
                DispatchQueue.main.async {
                    let profile = Profile(profileDTO: profileDTO)
                    completion(.success(profile))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMyNFT(with profile: Profile, completion: @escaping (Result<[NFT], Error>) -> Void) {
        nftApi.getNfts { result in
            switch result {
            case .success(let nftsDTO):
                DispatchQueue.main.async {
                    let nfts = nftsDTO.map { NFT(nftDTO: $0) }
                    let nftsFiltered = nfts.filter({ profile.nfts.contains( Int($0.id) ?? 0 ) })
                    completion(.success(nftsFiltered))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getFavoritesNFT(completion: @escaping (Result<[NFT], Error>) -> Void) {
        getUser { [weak self] result in
            switch result{
            case .success(let profile):
                self?.getFavoritesNftWithProfile(with: profile) { result in
                    switch result{
                    case .success(let nfts):
                        DispatchQueue.main.async {
                            completion(.success(nfts))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func getFavoritesNftWithProfile(with profile: Profile, completion: @escaping (Result<[NFT], Error>) -> Void) {
        nftApi.getNfts { result in
            switch result {
            case .success(let nftsDTO):
                DispatchQueue.main.async {
                    let nfts = nftsDTO.map { NFT(nftDTO: $0) }
                    let nftsFiltered = nfts.filter({ profile.likes.contains( Int($0.id) ?? 0 ) })
                    completion(.success(nftsFiltered))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
