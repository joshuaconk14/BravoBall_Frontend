import Foundation

// Cache keys
enum CacheKey: String {
    case orderedDrills = "orderedDrills"
    case savedDrills = "savedDrills"
    case likedDrills = "likedDrills"
    case userPreferences = "userPreferences"
    case lastUpdated = "lastUpdated_"
}

class CacheManager {
    static let shared = CacheManager()
    
    private let userDefaults = UserDefaults.standard
    
    // Memory cache
    private var memoryCache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = 100 // Adjust based on your needs
        return cache
    }()
    
    private init() {}
    
    // MARK: - Cache Operations
    
    func cache<T: Codable>(_ object: T, forKey key: String) {
        // Save to memory cache
        if let encoded = try? JSONEncoder().encode(object) {
            memoryCache.setObject(encoded as AnyObject, forKey: key as NSString)
            
            // Save to UserDefaults
            userDefaults.set(encoded, forKey: key)
            
            // Update timestamp
            userDefaults.set(Date(), forKey: CacheKey.lastUpdated.rawValue + key)
        }
    }
    
    func retrieve<T: Codable>(forKey key: String) -> T? {
        // Try memory cache first
        if let cached = memoryCache.object(forKey: key as NSString) as? Data,
           let decoded = try? JSONDecoder().decode(T.self, from: cached) {
            return decoded
        }
        
        // Try UserDefaults if not in memory
        if let data = userDefaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            // Update memory cache
            memoryCache.setObject(data as AnyObject, forKey: key as NSString)
            return decoded
        }
        
        return nil
    }
    
    func clearCache(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        userDefaults.removeObject(forKey: key)
        userDefaults.removeObject(forKey: CacheKey.lastUpdated.rawValue + key)
    }
    
    func clearAllCache() {
        memoryCache.removeAllObjects()
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
    
    // MARK: - Cache Validation
    
    func isDataStale(forKey key: String, staleAfter timeInterval: TimeInterval) -> Bool {
        guard let lastUpdated = userDefaults.object(forKey: CacheKey.lastUpdated.rawValue + key) as? Date else {
            return true
        }
        return Date().timeIntervalSince(lastUpdated) > timeInterval
    }
} 