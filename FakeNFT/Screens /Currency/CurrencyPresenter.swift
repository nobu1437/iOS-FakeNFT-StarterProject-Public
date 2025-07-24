import Foundation

final class CurrencyPresenter {
    
    // MARK: - Properties
    
    weak var view: CurrencyViewControllerProtocol?
    private let currencyService: CurrencyServiceProtocol
    
    // MARK: - Initializers
    
    init(currencyService: CurrencyServiceProtocol) {
        self.currencyService = currencyService
    }
    
    // MARK: - Private Methods
    
    private func buildScreenModel(onResponse: @escaping(Result<CurrenciesScreenModel, Error>) -> Void) {
        currencyService.getCurrencies{ result in
            switch result {
            case .success(let currencies):
                onResponse(.success(CurrenciesScreenModel(currencies: currencies)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
    
    private func showError() {
        view?.showError(
            title: NSLocalizedString("ErrorPaymentAlert.text",
                                     comment: ""),
            message: nil
        )
    }
}

// MARK: - CurrencyPresenterProtocol

extension CurrencyPresenter: CurrencyPresenterProtocol {
    func setupData() {
        view?.showProgressHud()
        buildScreenModel{ [view] result in
            switch result {
            case .success(let model):
                view?.hideProgressHud()
                view?.setup(with: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func pay(in currencyId: String?) {
        guard let currencyId else {
            showError()
            return
        }
        
        view?.showProgressHud()
        currencyService.pay(
            currencyId: currencyId) {[view, showError] result in
                view?.hideProgressHud()
                switch result {
                case .success(let payment):
                    if payment.success {
                        view?.showPaymentSuccess()
                    } else {
                        showError()
                    }
                    
                case .failure(let error):
                    print(error)
                    showError()
                }
            }
    }
}
