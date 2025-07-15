import Foundation

struct CartScreenModel {
    let items: [CartItemModel]
    let itemsCount: Int
    
    var totalPrice: Double {
        items.reduce(0) {$0 + $1.price}
    }
    
    init(items: [CartItemModel]) {
        self.items = items
        self.itemsCount = items.count
    }
}
