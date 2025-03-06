//
//  UserDataManager.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/5/25.
//

import Foundation

//class UserDataManager {
//    private let secureStorage: SecureStorageService
//    
//    // User-specific storage paths
//    private func userStoragePath(for userId: String) -> String {
//        return "users/\(userId)/data"
//    }
//    
//    // Session storage for specific user
//    private func userSessionKey(for userId: String) -> String {
//        return "users/\(userId)/current_session"
//    }
//    
//    func clearUserData(for userId: String) {
//        // Clear user's data when they logout
//        try? secureStorage.delete(key: userStoragePath(for: userId))
//        try? secureStorage.delete(key: userSessionKey(for: userId))
//    }
//}
