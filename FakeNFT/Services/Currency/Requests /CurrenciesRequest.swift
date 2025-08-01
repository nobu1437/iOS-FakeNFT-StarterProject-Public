import Foundation

struct CurrenciesRequest: NetworkRequest {
    var endpoint: URL?
    var token: String?
    
    init() {
        self.endpoint = URL(string:"\(RequestConstants.baseURL)/api/v1/currencies")
        self.token = RequestConstants.token
    }
}
