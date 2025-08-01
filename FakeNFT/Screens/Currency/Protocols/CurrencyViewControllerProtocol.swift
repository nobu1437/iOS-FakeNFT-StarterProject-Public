import Foundation

protocol CurrencyViewControllerProtocol: AnyObject, Loadable, ErrorPresentable {
    func setup(with data: CurrenciesScreenModel)
    func showPaymentSuccess()
}
