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
}
