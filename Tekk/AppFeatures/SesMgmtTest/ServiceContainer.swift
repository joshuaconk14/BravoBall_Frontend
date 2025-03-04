//
//  ServiceContainer.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/4/25.
//
import Foundation

final class ServiceContainer {
    static let shared = ServiceContainer()
    
    let encryption: EncryptionService
    let secureStorage: SecureStorageService
    
    private init() {
        // Initialize services
        do {
            self.encryption = try EncryptionService()
            self.secureStorage = SecureStorageService(encryption: encryption)
        } catch {
            fatalError("Failed to initialize services: \(error)")
        }
    }
}
