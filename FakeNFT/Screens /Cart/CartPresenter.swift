import Foundation

final class CartPresenter {
    
    // MARK: - Properties
    
    weak var view: CartViewProtocol?
    private let cartService: CartServiceProtocol
    private var items = [CartItemModel]()
    var needsReloadAfterReturning = true
    private var ids: [String] = []
    
    // MARK: - Initializers
    
    init(cartService: CartServiceProtocol) {
        self.cartService = cartService
    }
    
    // MARK: - Public Methods
    
    func sort (by option: SortOption ) {
        UserDefaultsService.shared.sortOption = option
        
        switch option {
        case .name:
            items.sort { $0.title < $1.title}
        case .price:
            items.sort { $0.price < $1.price}
        case .rating:
            items.sort { $0.rating > $1.rating}
        }
        
        let model = CartScreenModel(items: items)
        view?.update(with: model)
    }
    
    // MARK: - Private Methods
    
    private func buildScreenModel(onResponse: @escaping (Result<CartScreenModel, Error>) -> Void) {
        cartService.getCartItems { [weak self] result in
            switch result {
            case .success(let items):
                self?.ids = items.1
                self?.items = items.0
                onResponse(.success(CartScreenModel(items: items.0)))
            case .failure(let error):
                onResponse(.failure(error))
            }
        }
    }
}

// MARK: - CartPresenterProtocol

extension CartPresenter: CartPresenterProtocol {
    
    func deleteNft(id: String) {
        ids.removeAll {$0 == id}
        items.removeAll {$0.id == id}
        cartService.updateCart(ids) { [weak self] result in
            switch result {
            case .success(let ids):
                guard let self else {return}
                self.ids = ids
                self.view?.updateAfterDelete(with: CartScreenModel(items: self.items), deletedId: id)
            case .failure(let error):
                print(error)
            }
        }
    }
        
        func setup() {
            if !needsReloadAfterReturning {
                needsReloadAfterReturning = true
                return
            }
            
            view?.showProgressHud()
            buildScreenModel {[weak self] result in
                guard let self = self else {return}
                
                switch result {
                case .success(let model):
                    if let sortOption = UserDefaultsService.shared.sortOption {
                        self.sort(by: sortOption)
                    } else {
                        self.view?.update(with: model)
                    }
                case .failure(let error):
                    print(error)
                }
                
                self.view?.hideProgressHud()
            }
        }
    }
    
