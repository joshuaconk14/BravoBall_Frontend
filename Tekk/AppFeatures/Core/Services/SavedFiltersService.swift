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
        print("\n🔄 Syncing saved filters...")
        
        // First get existing filters to compare
        let existingFilters = try await fetchSavedFilters()
        
        // Look at each filter in the savedFilters array
        for filter in savedFilters {
            do {
                // Check if the filter already exists in the backend
                if existingFilters.contains(where: { $0.id == filter.id }) {
                    // Update existing filter
                    let url = URL(string: "\(baseURL)/api/filters/\(filter.id)")!
                    var request = URLRequest(url: url)
                    // PUT request to update the filter
                    request.httpMethod = "PUT"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // Add auth token
                    if let token = KeychainWrapper.standard.string(forKey: "authToken") {
                        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    }
                    
                    // Convert the filter to a dictionary
                    let filterData: [String: Any] = [
                        "name": filter.name,
                        "saved_time": filter.savedTime as Any,
                        "saved_equipment": Array(filter.savedEquipment),
                        "saved_training_style": filter.savedTrainingStyle as Any,
                        "saved_location": filter.savedLocation as Any,
                        "saved_difficulty": filter.savedDifficulty as Any
                    ]
                    
                    // Convert the dictionary to data
                    request.httpBody = try JSONSerialization.data(withJSONObject: filterData)
                    
                    // Send the request and get the response
                    let (_, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    
                    print("✅ Updated filter: \(filter.name)")
                } else {
                    // Create new filter
                    let url = URL(string: "\(baseURL)/api/filters/")!
                    var request = URLRequest(url: url)
                    // POST request to create the filter
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // Add auth token
                    if let token = KeychainWrapper.standard.string(forKey: "authToken") {
                        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    }
                    
                    // Convert the filter to a dictionary
                    let filterData: [String: Any] = [
                        "id": filter.id.uuidString,
                        "name": filter.name,
                        "saved_time": filter.savedTime as Any,
                        "saved_equipment": Array(filter.savedEquipment),
                        "saved_training_style": filter.savedTrainingStyle as Any,
                        "saved_location": filter.savedLocation as Any,
                        "saved_difficulty": filter.savedDifficulty as Any
                    ]
                    
                    // Convert the dictionary to data
                    request.httpBody = try JSONSerialization.data(withJSONObject: filterData)
                    
                    // Send the request and get the response
                    let (_, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    
                    print("✅ Created new filter: \(filter.name)")
                }
            } catch {
                print("❌ Error syncing filter '\(filter.name)': \(error)")
                throw error
            }
        }
        
        print("✅ Successfully synced all filters")
    }

    // Add the fetch function to get all saved filters from the backend
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
            // Send the request and get the response
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check the response
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw URLError(.badServerResponse)
            }
            
            print("📥 Response status code: \(httpResponse.statusCode)")
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 Response body: \(responseString)")
            }
            
            // Handle the response
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

