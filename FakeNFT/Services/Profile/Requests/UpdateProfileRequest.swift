//
//  UpdateProfileRequest.swift
//  FakeNFT
//
//  Created by mpplokhov on 24.07.2025.
//

import Foundation

struct UpdateProfileRequest: NetworkRequest {
    var contentType: String { "application/x-www-form-urlencoded" }
    var endpoint: URL?
    var token: String?
    var httpMethod: HttpMethod = .put
    var dto: Encodable?

    init(dto: UpdateProfileDTO) {
        self.endpoint = URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
        self.token = RequestConstants.token
        self.dto = dto
    }
}
