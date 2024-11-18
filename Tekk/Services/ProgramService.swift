//
//  ProgramService.swift
//  BravoBall
//
//  Created by Jordan on 11/12/24.
//

import Foundation

class ProgramService {
    static let shared = ProgramService()
    
    func fetchUserProgram(userId: Int) async throws -> Program {
        guard let url = URL(string: "\(AppSettings.baseURL)/api/program/\(userId)") else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ProgramResponse.self, from: data)
        return response.program
    }
}

struct ProgramResponse: Codable {
    let currentWeek: Int
    let program: Program
}
