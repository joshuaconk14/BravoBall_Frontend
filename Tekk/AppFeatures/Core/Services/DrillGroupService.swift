//
//  DrillGroupService.swift
//  BravoBall
//
//  Created by Jordan on 3/17/25.
//

import Foundation
import SwiftKeychainWrapper

// Models for API interactions
struct DrillGroupResponse: Decodable {
    let id: Int
    let name: String
    let description: String
    let drills: [DrillResponse]
    let isLikedGroup: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, drills
        case isLikedGroup = "is_liked_group"
    }
}

struct DrillGroupRequest: Encodable {
    let name: String
    let description: String
    let drill_ids: [Int]
    let isLikedGroup: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, description
        case drill_ids
        case isLikedGroup = "is_liked_group"
    }
}

struct DrillLikeResponse: Decodable {
    let message: String
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case message
        case isLiked = "is_liked"
    }
}

struct IsLikedResponse: Decodable {
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case isLiked = "is_liked"
    }
}

class DrillGroupService {
    static let shared = DrillGroupService()
    private let baseURL = AppSettings.baseURL
    
    private init() {}
    
    // Helper method to get auth token
    private func getAuthToken() -> String? {
        return KeychainWrapper.standard.string(forKey: "authToken")
    }
    
    // MARK: - Drill Group Methods
    
    /// Get all drill groups for the current user
    func getAllDrillGroups() async throws -> [DrillGroupResponse] {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully retrieved drill groups")
            return try JSONDecoder().decode([DrillGroupResponse].self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to retrieve drill groups"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Get a specific drill group by ID
    func getDrillGroup(groupId: Int) async throws -> DrillGroupResponse {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/\(groupId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully retrieved drill group \(groupId)")
            return try JSONDecoder().decode(DrillGroupResponse.self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to retrieve drill group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Create a new drill group
    func createDrillGroup(name: String, description: String, drills: [DrillResponse] = [], isLikedGroup: Bool = false) async throws -> DrillGroupResponse {
        // Extract IDs from DrillResponse objects and call the ID-based method
        let drillIds = drills.map { $0.id }
        return try await createDrillGroupWithIds(
            name: name,
            description: description,
            drillIds: drillIds,
            isLikedGroup: isLikedGroup
        )
    }
    
    /// Update an existing drill group
    func updateDrillGroup(groupId: Int, name: String, description: String, drills: [DrillResponse], isLikedGroup: Bool) async throws -> DrillGroupResponse {
        // Extract IDs from DrillResponse objects and call the ID-based method
        let drillIds = drills.map { $0.id }
        return try await updateDrillGroupWithIds(
            groupId: groupId,
            name: name,
            description: description,
            drillIds: drillIds,
            isLikedGroup: isLikedGroup
        )
    }
    
    /// Create a new drill group with drill IDs directly
    func createDrillGroupWithIds(name: String, description: String, drillIds: [Int], isLikedGroup: Bool) async throws -> DrillGroupResponse {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let groupRequest = DrillGroupRequest(
            name: name,
            description: description,
            drill_ids: drillIds,
            isLikedGroup: isLikedGroup
        )
        
        request.httpBody = try JSONEncoder().encode(groupRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
            print("✅ Successfully created drill group: \(name)")
            return try JSONDecoder().decode(DrillGroupResponse.self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to create drill group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Update a drill group with drill IDs directly
    func updateDrillGroupWithIds(groupId: Int, name: String, description: String, drillIds: [Int], isLikedGroup: Bool) async throws -> DrillGroupResponse {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/\(groupId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create request body
        let groupRequest = DrillGroupRequest(
            name: name,
            description: description,
            drill_ids: drillIds,
            isLikedGroup: isLikedGroup
        )
        
        request.httpBody = try JSONEncoder().encode(groupRequest)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully updated drill group \(groupId)")
            return try JSONDecoder().decode(DrillGroupResponse.self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to update drill group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Delete a drill group
    func deleteDrillGroup(groupId: Int) async throws -> String {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/\(groupId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully deleted drill group \(groupId)")
            let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
            return jsonResponse["message"] ?? "Drill group deleted successfully"
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to delete drill group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    // MARK: - Drill in Group Methods
    
    /// Add a drill to a group
    func addDrillToGroup(groupId: Int, drillId: Int) async throws -> String {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/\(groupId)/drills/\(drillId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully added drill \(drillId) to group \(groupId)")
            let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
            return jsonResponse["message"] ?? "Drill added to group successfully"
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to add drill to group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Remove a drill from a group
    func removeDrillFromGroup(groupId: Int, drillId: Int) async throws -> String {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drill-groups/\(groupId)/drills/\(drillId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully removed drill \(drillId) from group \(groupId)")
            let jsonResponse = try JSONDecoder().decode([String: String].self, from: data)
            return jsonResponse["message"] ?? "Drill removed from group successfully"
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to remove drill from group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    // MARK: - Liked Drills Methods
    
    /// Get or create the Liked Drills group
    func getLikedDrillsGroup() async throws -> DrillGroupResponse {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/liked-drills")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully retrieved Liked Drills group")
            return try JSONDecoder().decode(DrillGroupResponse.self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to retrieve Liked Drills group"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Toggle like status for a drill
    func toggleDrillLike(drillId: Int) async throws -> DrillLikeResponse {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drills/\(drillId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully toggled like status for drill \(drillId)")
            return try JSONDecoder().decode(DrillLikeResponse.self, from: data)
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to toggle drill like status"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
    
    /// Check if a drill is liked
    func checkDrillLiked(drillId: Int) async throws -> Bool {
        guard let token = getAuthToken() else {
            throw NSError(domain: "DrillGroupService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found"])
        }
        
        let url = URL(string: "\(baseURL)/api/drills/\(drillId)/like")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "DrillGroupService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
        }
        
        if httpResponse.statusCode == 200 {
            print("✅ Successfully checked like status for drill \(drillId)")
            let isLikedResponse = try JSONDecoder().decode(IsLikedResponse.self, from: data)
            return isLikedResponse.isLiked
        } else {
            let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
            let errorMessage = errorResponse?.detail ?? "Failed to check drill like status"
            throw NSError(domain: "DrillGroupService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        }
    }
}

// Simple error response struct for decoding API errors
private struct ErrorResponse: Decodable {
    let detail: String
}
