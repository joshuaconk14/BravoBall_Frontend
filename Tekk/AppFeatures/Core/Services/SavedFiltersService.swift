//
//  SavedFiltersService.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/26/25.
//

import Foundation
import SwiftKeychainWrapper

class SavedFiltersService {
    static let shared = SavedFiltersService()
    private let baseURL = AppSettings.baseURL
    
    func syncSavedFilters(savedFilters: [SavedFiltersModel]) async throws {
        let url = URL(string: "\(baseURL)/api/filters/")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token
        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Using auth token: \(token)")
        } else {
            print("⚠️ No auth token found!")
        }
        
        // Convert saved filters to dictionary format
        let filtersData = savedFilters.map { filter in
            return [
                "id": filter.id.uuidString,  // Send client UUID
                "backend_id": filter.backendId as Any,  // Send backend ID if available
                "name": filter.name,
                "saved_time": filter.savedTime as Any,
                "saved_equipment": Array(filter.savedEquipment),
                "saved_training_style": filter.savedTrainingStyle as Any,
                "saved_location": filter.savedLocation as Any,
                "saved_difficulty": filter.savedDifficulty as Any
            ]
        }
        
        let requestData = ["saved_filters": filtersData]
        
        print("📤 Sending request to: \(url.absoluteString)")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request body: \(requestData)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestData)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw URLError(.badServerResponse)
            }
            
            print("📥 Response status code: \(httpResponse.statusCode)")
            print("📥 Response headers: \(httpResponse.allHeaderFields)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response body: \(responseString)")
            }
            
            switch httpResponse.statusCode {
            case 200:
                print("✅ Successfully synced saved filters")
                // TODO: Update local models with backend IDs from response if needed
            case 401:
                print("❌ Unauthorized - Invalid or expired token")
                print("🔑 Current token: \(KeychainWrapper.standard.string(forKey: "authToken") ?? "no token")")
                throw URLError(.userAuthenticationRequired)
            case 404:
                print("❌ Endpoint not found - Check API route: \(url.absoluteString)")
                throw URLError(.badURL)
            case 422:
                if let responseString = String(data: data, encoding: .utf8) {
                    print("❌ Validation error: \(responseString)")
                }
                throw URLError(.badServerResponse)
            default:
                print("❌ Unexpected status code: \(httpResponse.statusCode)")
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response body: \(responseString)")
                }
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ Error during request: \(error)")
            throw error
        }
    }

    // Add the fetch function
    func fetchSavedFilters() async throws -> [SavedFiltersModel] {
        let url = URL(string: "\(baseURL)/api/filters/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token
        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔑 Using auth token: \(token)")
        } else {
            print("⚠️ No auth token found!")
            throw URLError(.userAuthenticationRequired)
        }
        
        print("📤 Fetching saved filters from: \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw URLError(.badServerResponse)
            }
            
            print("📥 Response status code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response body: \(responseString)")
            }
            
            switch httpResponse.statusCode {
            case 200:
                let decoder = JSONDecoder()
                let filters = try decoder.decode([SavedFilterResponse].self, from: data)
                
                // Convert backend response to our model
                return filters.map { response in
                    SavedFiltersModel(
                        id: UUID(uuidString: response.client_id) ?? UUID(),
                        backendId: response.id,
                        name: response.name,
                        savedTime: response.saved_time,
                        savedEquipment: Set(response.saved_equipment),
                        savedTrainingStyle: response.saved_training_style,
                        savedLocation: response.saved_location,
                        savedDifficulty: response.saved_difficulty
                    )
                }
                
            case 401:
                print("❌ Unauthorized - Invalid or expired token")
                throw URLError(.userAuthenticationRequired)
            case 404:
                print("❌ Endpoint not found")
                throw URLError(.badURL)
            default:
                print("❌ Unexpected status code: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }
        } catch {
            print("❌ Error fetching saved filters: \(error)")
            throw error
        }
    }
    
    // Response model matching backend format
    private struct SavedFilterResponse: Codable {
        let id: Int
        let client_id: String
        let name: String
        let saved_time: String?
        let saved_equipment: [String]
        let saved_training_style: String?
        let saved_location: String?
        let saved_difficulty: String?
    }
}

