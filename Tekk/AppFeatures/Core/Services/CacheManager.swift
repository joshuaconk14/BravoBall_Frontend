//
//  CacheManager.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/7/25.
//

import Foundation
import SwiftKeychainWrapper

// Cache keys
enum CacheKey: String, CaseIterable {
    case version = "cache_version"
    case orderedDrills = "orderedDrills"
    case savedDrills = "savedDrills"
    case likedDrills = "likedDrills"
    case filterGroups = "filterGroups"
    case lastUpdated = "lastUpdated_"
    case cacheSize = "cache_size"
    
    // Create user-specific key
    func forUser(_ email: String) -> String {
        if self == .version || self == .cacheSize {
            return self.rawValue
        }
        return "\(email)_\(self.rawValue)"
    }
}

class CacheManager {
    static let shared = CacheManager()
    
    private let userDefaults = UserDefaults.standard
    private let currentCacheVersion = "1.0"
    private let maxCacheSize = 50 * 1024 * 1024 // 50MB limit
    private var currentCacheSize: Int = 0
    private let keychain = KeychainWrapper.standard
    
    // Memory cache
    private var memoryCache: NSCache<NSString, AnyObject> = {
        let cache = NSCache<NSString, AnyObject>()
        cache.countLimit = 100 // Adjust based on your needs
        return cache
    }()
    
    private init() {
        setupCache()
    }
    
    // makes sure cache data is up-to-date and conforms to newest version
    private func setupCache() {
        // Initialize or validate cache version
        let storedVersion = userDefaults.string(forKey: CacheKey.version.rawValue)
        if storedVersion != currentCacheVersion {
            clearAllCache()
            userDefaults.set(currentCacheVersion, forKey: CacheKey.version.rawValue)
            print("📦 Cache: Initialized new cache version \(currentCacheVersion)")
        }
        
        // Load current cache size
        currentCacheSize = userDefaults.integer(forKey: CacheKey.cacheSize.rawValue)
        print("📦 Cache: Current size: \(formatSize(currentCacheSize))")
    }
    
    // Get current user's email
    private func getCurrentUserEmail() -> String {
        return keychain.string(forKey: "userEmail") ?? ""
    }
    
    // MARK: - Cache Operations
    
    func cache<T: Codable>(_ object: T, forKey key: CacheKey) {
        let userEmail = getCurrentUserEmail()
        guard !userEmail.isEmpty else {
            print("❌ Cache: No user logged in")
            return
        }
        
        let userSpecificKey = key.forUser(userEmail)
        do {
            let encoded = try JSONEncoder().encode(object)
            let dataSize = encoded.count
            
            // Check if adding this data would exceed cache size limit
            if currentCacheSize + dataSize > maxCacheSize {
                print("⚠️ Cache: Size limit reached. Clearing old cache...")
                clearOldCache()
            }
            
            // Save to memory cache
            memoryCache.setObject(encoded as AnyObject, forKey: userSpecificKey as NSString)
            
            // Save to UserDefaults
            userDefaults.set(encoded, forKey: userSpecificKey)
            
            // Update timestamp and size
            userDefaults.set(Date(), forKey: CacheKey.lastUpdated.rawValue + userSpecificKey)
            updateCacheSize(adding: dataSize)
            
            print("✅ Cache: Successfully cached data for user: \(userEmail), key: \(key.rawValue)")
            print("📊 Cache: Data size: \(formatSize(dataSize))")
            print("📊 Cache: Total cache size: \(formatSize(currentCacheSize))")
        } catch {
            print("❌ Cache: Failed to cache object for key: \(key.rawValue)")
            print("❌ Cache: Error: \(error.localizedDescription)")
        }
    }
    
    func retrieve<T: Codable>(forKey key: CacheKey) -> T? {
        let userEmail = getCurrentUserEmail()
        guard !userEmail.isEmpty else {
            print("❌ Cache: No user logged in")
            return nil
        }
        
        let userSpecificKey = key.forUser(userEmail)
        
        // Try memory cache first
        if let cached = memoryCache.object(forKey: userSpecificKey as NSString) as? Data,
           let decoded = try? JSONDecoder().decode(T.self, from: cached) {
            print("✅ Cache: Retrieved from memory cache for user: \(userEmail), key: \(key.rawValue)")
            return decoded
        }
        
        // Try UserDefaults if not in memory
        if let data = userDefaults.data(forKey: userSpecificKey),
           let decoded = try? JSONDecoder().decode(T.self, from: data) {
            // Update memory cache
            memoryCache.setObject(data as AnyObject, forKey: userSpecificKey as NSString)
            print("✅ Cache: Retrieved from UserDefaults for user: \(userEmail), key: \(key.rawValue)")
            return decoded
        }
        
        print("⚠️ Cache: No data found for user: \(userEmail), key: \(key.rawValue)")
        return nil
    }
    
    func clearCache(forKey key: CacheKey) {
        let userEmail = getCurrentUserEmail()
        guard !userEmail.isEmpty else {
            print("❌ Cache: No user logged in")
            return
        }
        
        let userSpecificKey = key.forUser(userEmail)
        
        if let data = userDefaults.data(forKey: userSpecificKey) {
            updateCacheSize(removing: data.count)
        }
        
        memoryCache.removeObject(forKey: userSpecificKey as NSString)
        userDefaults.removeObject(forKey: userSpecificKey)
        userDefaults.removeObject(forKey: CacheKey.lastUpdated.rawValue + userSpecificKey)
        
        print("🗑️ Cache: Cleared cache for user: \(userEmail), key: \(key.rawValue)")
        print("📊 Cache: Current total size: \(formatSize(currentCacheSize))")
    }
    
    func clearUserCache() {
        let userEmail = getCurrentUserEmail()
        guard !userEmail.isEmpty else {
            print("❌ Cache: No user logged in")
            return
        }
        
        // Get all keys and remove user-specific ones
        let allKeys = Array(userDefaults.dictionaryRepresentation().keys)
        let userKeys = allKeys.filter { $0.hasPrefix(userEmail) }
        
        for key in userKeys {
            if let data = userDefaults.data(forKey: key) {
                updateCacheSize(removing: data.count)
            }
            userDefaults.removeObject(forKey: key)
            memoryCache.removeObject(forKey: key as NSString)
        }
        
        print("🗑️ Cache: Cleared all cache for user: \(userEmail)")
        print("📊 Cache: Current total size: \(formatSize(currentCacheSize))")
    }
    
    func clearAllCache() {
        memoryCache.removeAllObjects()
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
        currentCacheSize = 0
        userDefaults.set(0, forKey: CacheKey.cacheSize.rawValue)
        print("🗑️ Cache: Cleared all cache")
        print("📊 Cache: Reset total size to 0")
    }
    
    // MARK: - Cache Validation
    
    func isDataStale(forKey key: CacheKey, staleAfter timeInterval: TimeInterval) -> Bool {
        let userEmail = getCurrentUserEmail()
        guard !userEmail.isEmpty else {
            print("⚠️ Cache: No user logged in")
            return true
        }
        
        let userSpecificKey = key.forUser(userEmail)
        guard let lastUpdated = userDefaults.object(forKey: CacheKey.lastUpdated.rawValue + userSpecificKey) as? Date else {
            print("⚠️ Cache: No timestamp found for key: \(key.rawValue)")
            return true
        }
        
        let isStale = Date().timeIntervalSince(lastUpdated) > timeInterval
        if isStale {
            print("⚠️ Cache: Data is stale for key: \(key.rawValue)")
        }
        return isStale
    }
    
    // MARK: - Helper Methods
    
    private func updateCacheSize(adding size: Int) {
        currentCacheSize += size
        userDefaults.set(currentCacheSize, forKey: CacheKey.cacheSize.rawValue)
    }
    
    private func updateCacheSize(removing size: Int) {
        currentCacheSize = max(0, currentCacheSize - size)
        userDefaults.set(currentCacheSize, forKey: CacheKey.cacheSize.rawValue)
    }
    
    private func clearOldCache() {
        // Get all keys and their timestamps
        let allKeys = Array(userDefaults.dictionaryRepresentation().keys)
        let cacheKeys = allKeys.filter { !$0.hasPrefix(CacheKey.lastUpdated.rawValue) }
        
        // Sort by timestamp and remove oldest entries until under size limit
        for stringKey in cacheKeys {
            if currentCacheSize <= maxCacheSize * 3/4 { // Clear until 75% of max
                break
            }
            
            // Convert string key back to CacheKey if possible
            if let cacheKey = CacheKey.allCases.first(where: { $0.rawValue == stringKey }) {
                clearCache(forKey: cacheKey)
            }
        }
    }
    
    private func formatSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    
}
