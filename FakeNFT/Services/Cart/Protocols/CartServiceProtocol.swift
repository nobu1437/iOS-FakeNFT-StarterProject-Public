import Foundation

protocol CartServiceProtocol {
    func getCartItems(
        onResponse: @escaping (Result<(items: [CartItemModel], ids: [String]) ,Error>) -> Void
    )
    func updateCart(
        _ items: [String],
        onResponse: @escaping (Result<[String], Error>) -> Void
    )
}
