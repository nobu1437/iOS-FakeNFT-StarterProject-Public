//
//  GetProfileRequest.swift
//  FakeNFT
//
//  Created by mpplokhov on 23.07.2025.
//

import Foundation

struct GetProfileRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?

    init() {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        self.token = RequestConstants.token
    }
}
