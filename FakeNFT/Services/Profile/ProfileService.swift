//
//  ProfileService.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import Foundation

final class ProfileService: ProfileServiceProtocol {

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProfile(
        onResponse: @escaping (Result<ProfileModel, Error>) -> Void
    ) {
        let request = GetProfileRequest()

        networkClient.send(request: request, type: ProfileDTO.self) { result in
            switch result {
            case .success(let dto):
                let model = ProfileModel(
                    id: dto.id,
                    name: dto.name,
                    avatar: URL(string: dto.avatar) ?? URL(fileURLWithPath: ""),
                    description: dto.description ?? "",
                    website: URL(string: dto.website ?? ""),
                    myNftCount: dto.nfts.count,
                    likedNftCount: dto.likes.count
                )

                onResponse(.success(model))

            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }

    func updateProfile(
        dto: UpdateProfileDTO,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let request = UpdateProfileRequest(dto: dto)

        networkClient.send(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
