//
//  MockProfileService.swift
//  FakeNFT
//
//  Created by mpplokhov on 31.07.2025.
//

@testable import FakeNFT

final class MockProfileService: ProfileServiceProtocol {
    private let profile: ProfileModel

    init(profile: ProfileModel) {
        self.profile = profile
    }

    func fetchProfile(onResponse: @escaping (Result<ProfileModel, Error>) -> Void) {
        onResponse(.success(profile))
    }

    func updateProfile(dto: UpdateProfileDTO, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    func fetchNFT(id: String, onResponse: @escaping (Result<NFTModel, Error>) -> Void) {
    }
}
