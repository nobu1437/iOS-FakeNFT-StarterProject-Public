import Foundation

protocol CurrencyViewControllerProtocol: AnyObject, Loadable {
    func setup(with data: CurrenciesScreenModel)
}
