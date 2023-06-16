//
//  ProfilleService.swift
//  FakeNFT
//
//  Created by MacBook on 03.06.2023.
//

import Foundation

protocol ProfileService: Any {
    func getUser(completion: @escaping (Result<Profile, Error>) -> Void)
    func getMyNft(with profile: Profile, completion: @escaping (Result<[Nft], Error>) -> Void)
    func getFavoritesNft(completion: @escaping (Result<[Nft], Error>) -> Void)
    func updateFavoritesNft(likes: [Nft])
    func updateProfile(_ profile: Profile)
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
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateProfile(_ profile: Profile) {
        nftApi.updateProfile(name: profile.name, description: profile.description, website: profile.website, likes: profile.likes) { _ in }
    }
    
    func getMyNft(with profile: Profile, completion: @escaping (Result<[Nft], Error>) -> Void) {
        nftApi.getNfts { result in
            switch result {
            case .success(let nftsDTO):
                DispatchQueue.main.async {
                    let nfts = nftsDTO.map { Nft(nftDTO: $0) }
                    let nftsFiltered = nfts.filter({ profile.nfts.contains($0.id) })
                    completion(.success(nftsFiltered))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getFavoritesNft(completion: @escaping (Result<[Nft], Error>) -> Void) {
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
    
    func updateFavoritesNft(likes: [Nft]) {
        let likesId = likes.compactMap { Int($0.id) }
        getUser { [weak self] result in
            switch result{
            case .success(let profile):
                let newProfile = Profile(id: profile.id, name: profile.name, description: profile.description, avatar: profile.avatar, website: profile.website, nfts: profile.nfts, likes: likesId)
                self?.updateProfile(newProfile)
            case .failure:
                return
            }
        }
    }
    
    private func getFavoritesNftWithProfile(with profile: Profile, completion: @escaping (Result<[Nft], Error>) -> Void) {
        nftApi.getNfts { result in
            switch result {
            case .success(let nftsDTO):
                DispatchQueue.main.async {
                    let nfts = nftsDTO.map { Nft(nftDTO: $0) }
                    let nftsFiltered = nfts.filter({ profile.likes.contains($0.id) })
                    completion(.success(nftsFiltered))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
