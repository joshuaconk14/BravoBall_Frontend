//
//  DrillService.swift
//  BravoBall
//
//  Created by Jordan on 12/30/24.
//

import Foundation

// DrillService is the service for fetching drill recommendations
class DrillService {
    // Singleton, so we can call it from anywhere. One instance of this class for global use. 
    static let shared = DrillService()
    
    // Fetch recommendations from the API
    func fetchRecommendations() async throws -> [DrillRecommendation] {
        // Create the URL
        guard let url = URL(string: "\(AppSettings.baseURL)/drills/recommendations/") else {
            throw URLError(.badURL)
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Add authentication header
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        
        // Make the API call
        let (data, _) = try await URLSession.shared.data(for: request)
        // Decode the response
        let response = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
        
        return response.recommendations
    }

    func fetchDrillCatalog(
    page: Int = 1,
    category: String? = nil,
    difficulty: String? = nil,
    equipment: [String]? = nil
    ) async throws -> DrillCatalogResponse {
        // Create the URL 
        var components = URLComponents(string: "\(AppSettings.baseURL)/drills/")!
        
        // Create the query items for the URL
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        // Add the category if it exists
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        // Add the difficulty if it exists
        if let difficulty = difficulty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        // Add the equipment if it exists
        if let equipment = equipment {
            queryItems.append(contentsOf: equipment.map { URLQueryItem(name: "equipment", value: $0) })
        }
        
        // Add the query items to the URL
        components.queryItems = queryItems
        
        // Create the request
        var request = URLRequest(url: components.url!)
        request.addValue("Bearer \(UserDefaults.standard.string(forKey: "authToken") ?? "")", forHTTPHeaderField: "Authorization")
        
        // Make the API call
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(DrillCatalogResponse.self, from: data)
    }
}
