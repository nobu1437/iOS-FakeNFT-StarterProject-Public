//
//  ProfileServiceProtocol.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

protocol ProfileServiceProtocol {
    func fetchProfile(
        onResponse: @escaping (Result<ProfileModel, Error>) -> Void
    )
    func updateProfile(
        dto: UpdateProfileDTO,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func fetchNFT(
        id: String,
        onResponse: @escaping (Result<NFTModel, Error>) -> Void
    )
}
