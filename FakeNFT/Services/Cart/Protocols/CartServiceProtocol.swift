import Foundation

protocol CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<([CartItemModel], [String]) ,Error>) -> Void
    )
    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<[String], Error>) -> Void
    )
}
