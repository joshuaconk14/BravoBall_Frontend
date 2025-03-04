//
//  SecureStorageService.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/4/25.
//

import Foundation
import Security

// 1. Define all errors
enum StorageError: Error {
    case saveError
    case loadError
    case deleteError
    case fileError
    case encryptionError
}

final class SecureStorageService {
    // 2. Storage types
    enum StorageType {
        case keychain // most secure
        case fileSystem
        case userDefaults // For non-sensitive settings
    }
    
    private let encryption: EncryptionService
    
    init(encryption: EncryptionService) {
        self.encryption = encryption
    }
    
    // 3. File URL helper
    private func getDocumentsURL(for filename: String) -> URL? {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(filename)
    }
    
    // 4. File operations
    private func saveToFile(_ data: Data, key: String) throws {
        guard let url = getDocumentsURL(for: key) else {
            throw StorageError.fileError
        }
        try data.write(to: url, options: .completeFileProtection)
    }
    
    private func loadFromFile(key: String) throws -> Data? {
        guard let url = getDocumentsURL(for: key) else {
            throw StorageError.fileError
        }
        return try? Data(contentsOf: url)
    }
    
    // 5. Keychain operations
    private func saveToKeychain(_ data: Data, key: String) throws {
        // dictionary to tell keychain what and how to store
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        // add item, error if unsuccessful
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.saveError
        }
    }
    
    private func loadFromKeychain(key: String) throws -> Data? {
        // dictionary to tell keychain what to look for and return
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess else {
            return nil
        }
        
        return result as? Data
    }
    
    // 6. Public interface
    func save<T: Encodable>(_ item: T, key: String, storage: StorageType) throws {
        let encryptedData = try encryption.encrypt(item)
        
        switch storage {
        case .keychain:
            try saveToKeychain(encryptedData, key: key)
        case .fileSystem:
            try saveToFile(encryptedData, key: key)
        case .userDefaults:
            UserDefaults.standard.set(encryptedData, forKey: key)
        }
    }
    
    func load<T: Decodable>(_ type: T.Type, key: String, storage: StorageType) throws -> T? {
        let encryptedData: Data?
        
        switch storage {
        case .keychain:
            encryptedData = try loadFromKeychain(key: key)
        case .fileSystem:
            encryptedData = try loadFromFile(key: key)
        case .userDefaults:
            encryptedData = UserDefaults.standard.data(forKey: key)
        }
        
        guard let data = encryptedData else { return nil }
        return try encryption.decrypt(data, as: T.self)
    }
}
