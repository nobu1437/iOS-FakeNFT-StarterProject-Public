//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by mpplokhov on 28.07.2025.
//

import Foundation

final class MyNFTPresenter {

    // MARK: - Properties

    weak var view: MyNFTViewProtocol?
    private let service: ProfileServiceProtocol
    private let profile: ProfileModel
    private var nftList: [NFTModel] = []

    // MARK: - Initializers

    init(service: ProfileServiceProtocol, profile: ProfileModel) {
        self.service = service
        self.profile = profile
    }
}

// MARK: - MyNFTPresenterProtocol

extension MyNFTPresenter: MyNFTPresenterProtocol {
    func loadNFTs() {
        nftList.removeAll()
        view?.showProgressHud()

        let group = DispatchGroup()

        for id in profile.nfts {
            group.enter()
            service.fetchNFT(id: id) { [weak self] result in
                defer { group.leave() }

                guard let self = self else { return }

                switch result {
                case .success(let nft):
                    self.nftList.append(nft)
                case .failure(let error):
                    print("Error loading NFT with id \(id): \(error)")
                }
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self else { return }

            self.view?.hideProgressHud()
            self.view?.update(with: self.nftList)
        }
    }

    func sortNFTs(by option: NFTSortOption) {
        switch option {
        case .price:
            nftList.sort { ($0.price as NSString).doubleValue < ($1.price as NSString).doubleValue }
        case .rating:
            nftList.sort { $0.rating > $1.rating }
        case .name:
            nftList.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
        view?.update(with: nftList)
    }
}

#if DEBUG
extension MyNFTPresenter {
    func setNFTListForTesting(_ list: [NFTModel]) {
        self.nftList = list
    }
}
#endif
