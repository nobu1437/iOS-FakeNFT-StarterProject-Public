import Foundation

protocol CurrencyServiceProtocol {
    func getCurrencies(onResponse: @escaping(Result<[CurrencyModel],Error>) -> Void)
    func pay(currencyId: String, onResponse: @escaping(Result<PaymentDTO, any Error>) -> Void)
}

