//
//  OnboardingService.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/8/25.
//

import Foundation
import SwiftUI


// Define the structure for the onboarding response
struct OnboardingResponse: Codable {
    let status: String
    let message: String
    let access_token: String // Use camelCase for Swift property names
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case access_token = "access_token" // Map JSON key to Swift property
        case tokenType = "token_type" // Map JSON key to Swift property
    }
}

// Submits onboarding data to the backend
class OnboardingService {
    static let shared = OnboardingService()
    
    func submitOnboardingData(data: OnboardingModel.OnboardingData) async throws -> OnboardingResponse {
        
        
        guard let url = URL(string: "\(AppSettings.baseURL)/api/onboarding") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(data)
        request.httpBody = jsonData
        
        print("📤 Sending onboarding data to: \(url.absoluteString)")
        print(String(data: jsonData, encoding: .utf8) ?? "")
        
        let (responseData, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📥 Backend response status: \(httpResponse.statusCode)")
        if let responseString = String(data: responseData, encoding: .utf8) {
            print("Response: \(responseString)")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
            
            
        }
        // Decode the response into OnboardingResponse
        let onboardingResponse = try JSONDecoder().decode(OnboardingResponse.self, from: responseData)
        
        return onboardingResponse
    }
}
