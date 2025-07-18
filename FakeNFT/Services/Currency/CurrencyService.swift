import Foundation

final class CurrencyService: CurrencyServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    convenience init() {
        self.init(networkClient: DefaultNetworkClient())
    }
    
    func getCurrencies(onResponse: @escaping (Result<[CurrencyModel], any Error>) -> Void) {
        let request = CurrenciesRequest()
        networkClient.send(
            request: request,
            type: [CurrencyModel].self) { result in
                switch result {
                case .success(let models):
                    onResponse(.success(models))
                case .failure(let error):
                    onResponse(.failure(error))
                }
            }
    }
}
