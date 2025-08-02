//
//  ProfileDTO.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

struct ProfileDTO: Codable {
    let id: String
    let name: String
    let avatar: String
    let description: String?
    let website: String?
    let nfts: [String]
    let likes: [String]
}
