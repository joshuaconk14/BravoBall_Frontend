//
//  UserManager.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/10/25.
//

import Foundation
import SwiftUI
import SwiftKeychainWrapper


class UserManager: ObservableObject {

    
    private let keychain = KeychainWrapper.standard
    
    
    // Updates the currentUser instance of User structure
    func updateUserKeychain(email: String, firstName: String, lastName: String) {
        
        // Store in Keychain
        keychain.set(email, forKey: "userEmail")
        keychain.set(firstName, forKey: "userFirstName")
        keychain.set(lastName, forKey: "userLastName")
        
        print("✅ User data saved to Keychain")
        print("Email: \(email)")
        print("First Name: \(firstName)")
        print("Last Name: \(lastName)")
    }
    
    func clearUserKeychain() {
        // Clear Keychain
        keychain.removeObject(forKey: "userEmail")
        keychain.removeObject(forKey: "userFirstName")
        keychain.removeObject(forKey: "userLastName")
        
        
        print("✅ User data cleared from Keychain")
    }
    
    // Returns tuple of user info from () -> its types, must be in same order
    func getUserFromKeychain() -> (email: String, firstName: String, lastName: String) {
        let email = KeychainWrapper.standard.string(forKey: "userEmail") ?? ""
        let firstName = KeychainWrapper.standard.string(forKey: "userFirstName") ?? ""
        let lastName = KeychainWrapper.standard.string(forKey: "userLastName") ?? ""
        
        return (email, firstName, lastName)
        
    }
}
