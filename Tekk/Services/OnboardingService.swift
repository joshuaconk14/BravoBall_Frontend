//
//  OnboardingService.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation

class OnboardingService {
    static let shared = OnboardingService()
    private let baseURL = "YOUR_API_BASE_URL"
    
    func submitOnboardingData(data: OnboardingData, authToken: String) async throws {
        guard let url = URL(string: "\(baseURL)/onboarding") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let jsonData = try JSONEncoder().encode(data)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}