import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Key {
        static let sortOption = "sortOptionKey"
    }
    
    var sortOption: SortOption? {
        get {
            guard let rawValue = defaults.string(forKey: Key.sortOption) else { return nil}
            defaults.bool(forKey: Key.sortOption)
            
            return SortOption(rawValue: rawValue)
        }
        set {
            defaults.set(newValue, forKey: Key.sortOption)
        }
    }
    
}
