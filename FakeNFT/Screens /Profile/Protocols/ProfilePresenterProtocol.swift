//
//  ProfilePresenterProtocol.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import Foundation

protocol ProfilePresenterProtocol: AnyObject {
    func setup()
    func getEditProfileVC(for lastLoadedModel: ProfileModel) -> EditProfileViewController
}
