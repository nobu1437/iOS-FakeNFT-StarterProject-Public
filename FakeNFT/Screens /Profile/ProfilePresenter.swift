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

    // MARK: - Initializers
    
    init() {
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
}
