import Foundation

protocol CartViewProtocol: AnyObject {
    func update(with data: CartScreenModel)
    func showProgressHud()
    func hideProgressHud()
}
