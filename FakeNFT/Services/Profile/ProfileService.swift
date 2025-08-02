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
                    nfts: dto.nfts,
                    likes: dto.likes
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
    
    func fetchNFT(
        id: String,
        onResponse: @escaping (Result<NFTModel, Error>) -> Void
    ) {
        let request = GetNFTRequest(nftID: id)

        networkClient.send(request: request, type: NftDTO.self) { result in
            switch result {
            case .success(let dto):
                let model = NFTModel(
                    id: dto.id,
                    name: dto.name,
                    imageURL: dto.images.first,
                    rating: dto.rating,
                    price: String(format: "%.2f", dto.price),
                    author: dto.author?.absoluteString ?? NSLocalizedString("Profile.myNFT.authorUnknown", comment: ""),
                    description: dto.description
                )
                onResponse(.success(model))

            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}
