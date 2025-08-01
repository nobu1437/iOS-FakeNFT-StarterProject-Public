import Foundation

protocol CartViewProtocol: AnyObject {
    func update(with data: CartScreenModel)
    func updateAfterDelete(with data: CartScreenModel, deletedId: String)
    func showProgressHud()
    func hideProgressHud()
}
