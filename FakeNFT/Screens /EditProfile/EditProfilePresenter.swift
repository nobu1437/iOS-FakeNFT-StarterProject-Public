//
//  EditProfilePresenter.swift
//  FakeNFT
//
//  Created by mpplokhov on 24.07.2025.
//

import Foundation

final class EditProfilePresenter {
    
    weak var view: EditProfileViewProtocol?
    private let profileService: ProfileServiceProtocol
    private let currentProfile: ProfileModel

    private(set) var name: String
    private(set) var description: String
    private(set) var website: String
    private(set) var avatar: String
    private(set) var updatedProfile: ProfileModel?

    init(service: ProfileServiceProtocol, profile: ProfileModel) {
        self.profileService = service
        self.currentProfile = profile
        self.name = profile.name
        self.description = profile.description
        self.website = profile.website?.absoluteString ?? ""
        self.avatar = profile.avatar?.absoluteString ?? ""
    }
    
    func updateName(_ name: String) {
        self.name = name
    }

    func updateDescription(_ text: String) {
        self.description = text
    }

    func updateWebsite(_ website: String) {
        self.website = website
    }

    func updateAvatar(_ url: String) {
        self.avatar = url
    }
}

extension EditProfilePresenter: EditProfilePresenterProtocol {
    func saveProfileOnExit() {
        view?.showLoading()

        let dto = UpdateProfileDTO(
            name: name,
            description: description,
            website: website,
            avatar: avatar
        )

        profileService.updateProfile(dto: dto) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                self.view?.hideLoading()

                switch result {
                case .success:
                    let model = ProfileModel(
                        id: self.currentProfile.id,
                        name: self.name,
                        avatar: URL(string: self.avatar),
                        description: self.description,
                        website: URL(string: self.website),
                        myNftCount: self.currentProfile.myNftCount,
                        likedNftCount: self.currentProfile.likedNftCount
                    )

                    self.updatedProfile = model
                    self.view?.close()

                case .failure(let error):
                    self.view?.close()
                }
            }
        }
    }
}
