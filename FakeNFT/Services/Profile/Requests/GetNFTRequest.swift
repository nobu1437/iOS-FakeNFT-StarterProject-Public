//
//  GetNFTRequest.swift
//  FakeNFT
//
//  Created by mpplokhov on 28.07.2025.
//

import Foundation

struct GetNFTRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init(nftID: String) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(nftID)")
        self.token = RequestConstants.token
    }
}
