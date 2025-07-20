import Foundation

protocol CartPresenterProtocol: AnyObject {
    var needsReloadAfterReturning: Bool { get set }
    func setup()
    func sort(by option: SortOption)
    func deleteNft(id: String)
}
