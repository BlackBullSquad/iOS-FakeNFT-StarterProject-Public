//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by MacBook on 14.06.2023.
//

import Foundation

protocol ProfileViewModel {

    var profile: Profile? { get }
    var showErrorAlertState: Bool { get }
    
    func getProfile()
    func fetchViewTitleForCell(with indexPath: IndexPath) -> String
    func getMyNftVC() -> MyNftViewController?
    func getFavoritesNftVC() -> FavoritesNftViewController
    func getEditProfileVC() -> EditProfileViewController?
    //binding
    var profileDidChange: (() -> Void)? { get set }
    var showErrorAlertStateDidChange: (() -> Void)? { get set }
}

final class ProfileViewModelImpl: ProfileViewModel {

    // MARK: - Properties
    private let profileService: ProfileService
    private let settingsStorage: SettingsStorageProtocol

    private(set) var profile: Profile? {
        didSet {
            profileDidChange?()
        }
    }
    private(set) var showErrorAlertState = false {
        didSet {
            showErrorAlertStateDidChange?()
        }
    }

    var profileDidChange: (() -> Void)?
    var showErrorAlertStateDidChange: (() -> Void)?
    
    // MARK: - Initialiser
    init(profileService: ProfileService, settingsStorage: SettingsStorageProtocol) {
        self.profileService = profileService
        self.settingsStorage = settingsStorage
        initialization()
    }

    // MARK: - Methods
    private func initialization() {
        getProfile()
    }
    
    func fetchViewTitleForCell(with indexPath: IndexPath) -> String {
        var labelString = ""
        switch indexPath.row {
        case 0: labelString = "Мои NFT (\(profile?.nfts.count ?? 0))"
        case 1: labelString = "Избранные NFT (\(profile?.likes.count ?? 0))"
        case 2: labelString = "О разработчике"
        default:
            labelString = ""
        }
        return labelString
    }
    
    func getMyNftVC() -> MyNftViewController? {
        guard let profile = profile else { return nil }
        let viewModel = MyNftViewModelImpl(profileService: profileService, profile: profile, settingsStorage: settingsStorage)
        let vc = MyNftViewController(viewModel: viewModel)
        return vc
    }
    
    func getFavoritesNftVC() -> FavoritesNftViewController {
        let viewModel = FavoritesNftViewModelImpl(profileService: profileService)
        let vc = FavoritesNftViewController(viewModel: viewModel)
        return vc
    }
    
    func getEditProfileVC() -> EditProfileViewController? {
        guard let profile = profile else { return nil }
        let viewModel = EditProfileViewModelImpl(profile: profile, profileService: profileService)
        viewModel.updateProfile = { [weak self] profile in
            self?.profile = profile
        }
        let vc = EditProfileViewController(viewModel: viewModel)
        return vc
    }
    
    func getProfile() {
        profileService.getUser { [weak self] result in
            switch result{
            case .success(let profile):
                self?.showErrorAlertState = false
                self?.profile = profile
            case .failure:
                self?.showErrorAlertState = true
            }
        }
    }
}
