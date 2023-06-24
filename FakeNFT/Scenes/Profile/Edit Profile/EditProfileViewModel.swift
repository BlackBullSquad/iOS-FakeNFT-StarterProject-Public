//
//  EditProfileViewModel.swift
//  FakeNFT
//
//  Created by MacBook on 14.06.2023.
//

import Foundation

protocol EditProfileViewModel {

    var profile: Profile { get }

    func updateName(_ newName: String)
    func updateDescript(_ newDescript: String)
    func updateAvatar(_ newAvatar: URL)
    func updateWebsite(_ newWebsite: URL)
    func saveProfile(name: String?, descript: String?, websiteString: String?)
    // binding
//    var profileDidChange: (() -> Void)? { get set }
}

final class EditProfileViewModelImpl: EditProfileViewModel {

    // MARK: - Properties
    private let profileService: ProfileService
    private(set) var profile: Profile

    var updateProfile: ((Profile) -> Void)?

    private var name: String
    private var descript: String
    private var avatar: URL
    private var website: URL

    // MARK: - Initialiser
    init(profile: Profile, profileService: ProfileService) {
        self.profile = profile
        self.profileService = profileService
        self.name = profile.name
        self.descript = profile.description
        self.avatar = profile.avatar
        self.website = profile.website
        initialization()
    }

    // MARK: - Methods
    private func initialization() {

    }

    func updateName(_ newName: String) {
        name = newName
    }
    func updateDescript(_ newDescript: String) {
        descript = newDescript
    }
    func updateAvatar(_ newAvatar: URL) {
        avatar = newAvatar
    }
    func updateWebsite(_ newWebsite: URL) {
        website = newWebsite
    }

    func saveProfile(name: String?, descript: String?, websiteString: String?) {
        if let url = URL(string: websiteString ?? "") {
            website = url
        }
        let name = name ?? profile.name
        let descript = descript ?? profile.description
        let newProfile = Profile(id: profile.id,
                                 name: name,
                                 description: descript,
                                 avatar: avatar,
                                 website: website,
                                 nfts: profile.nfts,
                                 likes: profile.likes)

        profileService.updateProfile(newProfile)
        updateProfile?(newProfile)
    }
}
