//
//  SessionManagement.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/1/25.
//
import Foundation

//final class SessionManager: ObservableObject {
//    private let storage: SecureStorageServiceProtocol
//    private let encryption: EncryptionServiceProtocol
//    
//    @Published private(set) var currentSession: SessionData?
//    
//    // Cache with expiration
//    private var cache = NSCache<NSString, CachedSession>()
//    private let cacheTimeout: TimeInterval = 3600 // 1 hour
//    
//    func saveSession(_ session: SessionData) async throws {
//        let encrypted = try encryption.encrypt(session)
//        try storage.save(encrypted, key: "current_session")
//        
//        // Cache management
//        let cached = CachedSession(data: session, timestamp: Date())
//        cache.setObject(cached, forKey: "current_session" as NSString)
//    }
//}
