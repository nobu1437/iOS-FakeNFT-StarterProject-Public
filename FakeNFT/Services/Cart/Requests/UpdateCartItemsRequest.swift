import Foundation

struct UpdateCartItemsRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?
    var httpMethod: HttpMethod

    init(ids: [String]) {
        var url = "\(RequestConstants.baseURL)/api/v1/orders/1"
        for index in 0..<ids.count {
            let sepSymbol = index == 0 ? "?" : "&"
            url += "\(sepSymbol)nfts=\(ids[index])"
        }
        self.endpoint = URL(string: url)
        self.token = RequestConstants.token
        self.httpMethod = .put
    }
}
