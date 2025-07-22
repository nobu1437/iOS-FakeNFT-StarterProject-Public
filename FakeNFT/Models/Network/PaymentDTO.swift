import Foundation

struct PaymentDTO: Decodable {
    let success: Bool
    let orderId: String?
    let id: String?
}
