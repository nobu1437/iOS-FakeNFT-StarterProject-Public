//
//  MyNftViewProtocol.swift
//  FakeNFT
//
//  Created by mpplokhov on 28.07.2025.
//

protocol FavouritesNFTViewProtocol: AnyObject {
    func update(with nfts: [NFTModel])
    func showProgressHud()
    func hideProgressHud()
}
