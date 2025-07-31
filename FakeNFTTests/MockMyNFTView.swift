//
//  MockMyNFTView.swift
//  FakeNFT
//
//  Created by mpplokhov on 31.07.2025.
//

@testable import FakeNFT

final class MockMyNFTView: MyNFTViewProtocol {
    var updatedNFTs: [NFTModel] = []

    func update(with nfts: [NFTModel]) {
        updatedNFTs = nfts
    }

    func showProgressHud() {}
    func hideProgressHud() {}
}
