//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import Foundation

final class ProfilePresenter {
    
    // MARK: - Properties
    
    weak var view: ProfileViewProtocol?
    private let profileService: ProfileServiceProtocol

    // MARK: - Initializers
    
    init(profileService: ProfileServiceProtocol) {
        self.profileService = profileService
    }
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func setup() {
        view?.showProgressHud()
        
        profileService.fetchProfile() { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.view?.hideProgressHud()
                
                switch result {
                case .success(let model):
                    self.view?.update(with: model)
                case .failure(let error):
                    print("Failed to load profile: \(error.localizedDescription)")
                }
            }
        }
    }
}
