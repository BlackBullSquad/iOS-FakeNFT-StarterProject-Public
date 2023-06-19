//
//  FavoritesNftViewModel.swift
//  FakeNFT
//
//  Created by MacBook on 14.06.2023.
//

import Foundation

protocol FavoritesNftViewModel {

    var favoriteNfts: [Nft] { get }
    var showErrorAlertState: Bool { get }

    func likeButtonHandle(indexPath: IndexPath)
    func initialization()
    // binding
    var favoriteNftsDidChange: (() -> Void)? { get set }
    var showErrorAlertStateDidChange: (() -> Void)? { get set }
}

final class FavoritesNftViewModelImpl: FavoritesNftViewModel {

    // MARK: - Properties
    private let profileService: ProfileService

    private(set) var favoriteNfts: [Nft] = [] {
        didSet {
            favoriteNftsDidChange?()
        }
    }
    private(set) var showErrorAlertState = false {
        didSet {
            showErrorAlertStateDidChange?()
        }
    }

    var favoriteNftsDidChange: (() -> Void)?
    var showErrorAlertStateDidChange: (() -> Void)?

    // MARK: - Initialiser
    init(profileService: ProfileService) {
        self.profileService = profileService
        initialization()
    }

    // MARK: - Methods
    func initialization() {
        getFavoritesNfts()
    }

    func likeButtonHandle(indexPath: IndexPath) {
        favoriteNfts.remove(at: indexPath.row)
        profileService.updateFavoritesNft(likes: favoriteNfts)
    }

    private func getFavoritesNfts() {
        profileService.getFavoritesNft { [weak self] result in
            switch result {
            case .success(let myNfts):
                self?.showErrorAlertState = false
                self?.favoriteNfts = myNfts
            case .failure:
                self?.showErrorAlertState = true
            }
        }
    }

}
