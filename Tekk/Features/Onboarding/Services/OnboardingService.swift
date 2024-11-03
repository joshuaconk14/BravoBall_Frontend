//
//  OnboardingService.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation
import SwiftUI

class OnboardingService {
    static let shared = OnboardingService()
    
    func submitOnboardingData(data: OnboardingData) async throws {
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
    }
}
