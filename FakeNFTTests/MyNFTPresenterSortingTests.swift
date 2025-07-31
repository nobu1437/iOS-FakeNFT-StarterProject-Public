//
//  MyNFTPresenterSortingTests.swift
//  FakeNFT
//
//  Created by mpplokhov on 31.07.2025.
//

import XCTest
@testable import FakeNFT

final class MyNFTPresenterTests: XCTestCase {

    func testSortByPrice() {
        let view = MockMyNFTView()
        let presenter = makePresenter(with: sampleNFTs(), view: view)
        
        presenter.sortNFTs(by: .price)
        
        let sorted = view.updatedNFTs
        XCTAssertEqual(sorted.map { $0.id }, ["3", "2", "1"]) // 0.1 < 1.5 < 3.0
    }

    func testSortByRating() {
        let view = MockMyNFTView()
        let presenter = makePresenter(with: sampleNFTs(), view: view)

        presenter.sortNFTs(by: .rating)
        
        let sorted = view.updatedNFTs
        XCTAssertEqual(sorted.map { $0.id }, ["2", "3", "1"]) // 100 > 90 > 80
    }

    func testSortByName() {
        let view = MockMyNFTView()
        let presenter = makePresenter(with: sampleNFTs(), view: view)

        presenter.sortNFTs(by: .name)

        let sorted = view.updatedNFTs
        XCTAssertEqual(sorted.map { $0.id }, ["3", "1", "2"]) // Alpha, Beta, Omega
    }

    // Helpers

    private func makePresenter(with nfts: [NFTModel], view: MockMyNFTView) -> MyNFTPresenter {
        let profile = ProfileModel(id: "1", name: "", avatar: nil, description: "", website: nil, nfts: [], likes: [])
        let presenter = MyNFTPresenter(service: MockProfileService(profile: profile), profile: profile)
        presenter.view = view

        presenter.setNFTListForTesting(nfts)

        return presenter
    }

    private func sampleNFTs() -> [NFTModel] {
        return [
            NFTModel(id: "1", name: "Beta", imageURL: nil, rating: 80, price: "3.0", author: "", description: ""),
            NFTModel(id: "2", name: "Omega", imageURL: nil, rating: 100, price: "1.5", author: "", description: ""),
            NFTModel(id: "3", name: "Alpha", imageURL: nil, rating: 90, price: "0.1", author: "", description: "")
        ]
    }
}
