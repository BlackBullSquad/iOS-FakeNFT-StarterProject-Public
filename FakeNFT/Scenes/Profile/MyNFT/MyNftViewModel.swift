//
//  MyNftViewModel.swift
//  FakeNFT
//
//  Created by MacBook on 14.06.2023.
//

import Foundation

protocol MyNftViewModel {

    var myNfts: [Nft] { get }
    var likes: [Int] { get }
    var numberOfRowsInSection: Int { get }
    var showErrorAlertState: Bool { get }
    
    func sort(by descriptor: SortDescriptor)
    func likeButtonHandle(indexPath: IndexPath)
    func initialization()
    //binding
    var myNftsDidChange: (() -> Void)? { get set }
    var likesDidChange: (() -> Void)? { get set }
    var showErrorAlertStateDidChange: (() -> Void)? { get set }
}

final class MyNftViewModelImpl: MyNftViewModel {

    // MARK: - Properties
    private let profileService: ProfileService
    private let settingsStorage: SettingsStorageProtocol
    private let profile: Profile

    var numberOfRowsInSection: Int { myNfts.count }
    
    private(set) var myNfts: [Nft] = [] {
        didSet {
            myNftsDidChange?()
        }
    }
    private(set) var likes: [Int] = [] {
        didSet {
            likesDidChange?()
        }
    }
    private(set) var showErrorAlertState = false {
        didSet {
            showErrorAlertStateDidChange?()
        }
    }
    
    var myNftsDidChange: (() -> Void)?
    var likesDidChange: (() -> Void)?
    var showErrorAlertStateDidChange: (() -> Void)?
    
    // MARK: - Initialiser
    init(profileService: ProfileService, profile: Profile, settingsStorage: SettingsStorageProtocol) {
        self.profileService = profileService
        self.profile = profile
        self.settingsStorage = settingsStorage
        self.likes = profile.likes
        initialization()
    }

    // MARK: - Methods
    func initialization() {
        getMyNfts(with: profile)
    }
    
    private func getMyNfts(with: Profile) {
        profileService.getMyNft(with: profile) { [weak self] result in
            switch result{
            case .success(let myNfts):
                self?.showErrorAlertState = false
                self?.myNfts = myNfts
                self?.sortInit()
            case .failure:
                self?.showErrorAlertState = true
            }
        }
    }
    
    private func sortInit() {
        if let descriptor = settingsStorage.fetchSorting() {
            sort(by: descriptor)
        }
    }
    
    func sort(by descriptor: SortDescriptor) {
        switch descriptor {
        case .price:
            myNfts.sort(by: { $0.price < $1.price } )
        case .name:
            myNfts.sort(by: { $0.name < $1.name } )
        case .rating:
            myNfts.sort(by: { $0.rating < $1.rating } )
        }
        settingsStorage.saveSorting(descriptor)
    }
    
    func likeButtonHandle(indexPath: IndexPath) {
        let idNftLikeChange = myNfts[indexPath.row].id
        if likes.contains(idNftLikeChange) {
            likes.removeAll { $0 == idNftLikeChange }
        } else {
            likes.append(idNftLikeChange)
        }
        let newProfile = Profile(
            id: profile.id,
            name: profile.name,
            description: profile.description,
            avatar: profile.avatar,
            website: profile.website,
            nfts: profile.nfts,
            likes: likes
        )
        profileService.updateProfile(newProfile)
    }
}
