import Foundation

protocol CurrencyServiceProtocol {
    func getCurrencies(onResponse: @escaping(Result<[CurrencyModel],Error>) -> Void)
}

