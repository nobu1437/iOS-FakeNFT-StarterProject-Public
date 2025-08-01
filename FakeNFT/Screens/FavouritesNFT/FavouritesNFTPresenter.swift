//
//  FavouritesNFTPresenter.swift
//  FakeNFT
//
//  Created by mpplokhov on 29.07.2025.
//

import Foundation

final class FavouritesNFTPresenter: FavouritesNFTPresenterProtocol {

    weak var view: FavouritesNFTViewProtocol?
    private let service: ProfileServiceProtocol
    private let profile: ProfileModel

    init(service: ProfileServiceProtocol, profile: ProfileModel) {
        self.service = service
        self.profile = profile
    }

    func loadNFTs() {
        view?.showProgressHud()

        let group = DispatchGroup()
        var resultNFTs: [NFTModel] = []

        for nftId in profile.likes {
            group.enter()
            service.fetchNFT(id: nftId) { result in
                if case .success(let model) = result {
                    resultNFTs.append(model)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.view?.hideProgressHud()
            self.view?.update(with: resultNFTs)
        }
    }
}
