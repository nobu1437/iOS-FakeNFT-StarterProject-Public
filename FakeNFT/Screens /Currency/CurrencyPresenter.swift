import Foundation

protocol CurrencyPresenterProtocol {
    func setupData()
}

final class CurrencyPresenter {
    weak var view: CurrencyViewControllerProtocol?
    private let currencyService: CurrencyServiceProtocol
    
    init(currencyService: CurrencyServiceProtocol) {
        self.currencyService = currencyService
    }
    
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
}

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
}
