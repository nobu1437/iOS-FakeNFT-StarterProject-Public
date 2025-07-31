//
//  ProfileViewSnapshotTests.swift
//  FakeNFT
//
//  Created by mpplokhov on 31.07.2025.
//

import XCTest
import SnapshotTesting
@testable import FakeNFT

final class ProfileViewSnapshotTests: XCTestCase {

    func testProfileViewAppearance() {
        let mockProfile = ProfileModel(
            id: "1",
            name: "Alice",
            avatar: URL(string: "https://example.com/avatar.png"),
            description: "Collector of rare NFTs.",
            website: URL(string: "https://alice.example"),
            nfts: ["nft1", "nft2"],
            likes: ["nft2"]
        )

        let mockService = MockProfileService(profile: mockProfile)
        let presenter = ProfilePresenter(profileService: mockService)
        let viewController = ProfileViewController(presenter: presenter)
        presenter.view = viewController

        presenter.setup()

        assertSnapshot(of: viewController, as: .image(on: .iPhone13))
    }
}
