//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import Foundation

struct ProfileModel {
    let id: String
    let name: String
    let avatar: URL
    let description: String
    let website: URL?
    let myNftCount: Int
    let likedNftCount: Int
}
