//
//  EncryptionService.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/2/25.
//

import Foundation
import CryptoKit

final class EncryptionService {
    // Error types for encryption operations
    enum EncryptionError: Error {
        case encryptionFailed
        case decryptionFailed
        case keyGenerationFailed
    }
    
    // Symmetric key for encryption/decryption
    private let key: SymmetricKey
    
    init() throws {
        // Generate a random high-bit encryption key
        key = SymmetricKey(size: .bits256)
    }
    
    // Encrypt data of any type
    func encrypt<T: Encodable>(_ item: T) throws -> Data {
        let data = try JSONEncoder().encode(item)
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    // Decrypt data of any type
    func decrypt<T: Decodable>(_ data: Data, as type: T.Type) throws -> T {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return try JSONDecoder().decode(T.self, from: decryptedData)
    }
}
