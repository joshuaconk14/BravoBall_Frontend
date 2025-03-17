//
//  DataSyncService.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/12/25.
//

import Foundation
import SwiftKeychainWrapper

class DataSyncService {
    static let shared = DataSyncService()
    private let baseURL = AppSettings.baseURL
    
    // MARK: - User Preferences Sync
    
    func syncUserPreferences(selectedTime: String?,
                           selectedEquipment: Set<String>,
                           selectedTrainingStyle: String?,
                           selectedLocation: String?,
                           selectedDifficulty: String?,
                           currentStreak: Int,
                           highestStreak: Int,
                           completedSessionsCount: Int) async throws {
        let url = URL(string: "\(baseURL)/api/preferences/")!
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
        
        // Create a mutable dictionary to build our preferences
        var preferences: [String: Any] = [
            "selected_equipment": Array(selectedEquipment),
            "selected_time": selectedTime as Any,
            "selected_training_style": selectedTrainingStyle as Any,
            "selected_location": selectedLocation as Any,
            "selected_difficulty": selectedDifficulty as Any,
            "current_streak": currentStreak,
            "highest_streak": highestStreak,
            "completed_sessions_count": completedSessionsCount
        ]
        
        print("📤 Sending request to: \(url.absoluteString)")
        print("Request headers: \(request.allHTTPHeaderFields ?? [:])")
        print("Request body: \(preferences)")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: preferences)
            
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
                print("✅ Successfully synced user preferences")
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
    
    // MARK: - Completed Sessions Sync
    
    func syncCompletedSession(date: Date, drills: [EditableDrillModel], totalCompleted: Int, total: Int) async throws {
        let url = URL(string: "\(baseURL)/api/sessions/completed/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token
        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Convert drills to dictionary format
        let drillsData = drills.map { drill in
            return [
                "drill": [
                    "id": drill.drill.id.uuidString,
                    "title": drill.drill.title,
                    "skill": drill.drill.skill,
                    "sets": drill.totalSets,
                    "reps": drill.totalReps,
                    "duration": drill.totalDuration,
                    "description": drill.drill.description,
                    "tips": drill.drill.tips,
                    "equipment": drill.drill.equipment,
                    "trainingStyle": drill.drill.trainingStyle,
                    "difficulty": drill.drill.difficulty
                ],
                "setsDone": drill.setsDone,
                "totalSets": drill.totalSets,
                "totalReps": drill.totalReps,
                "totalDuration": drill.totalDuration,
                "isCompleted": drill.isCompleted
            ]
        }
        
        let sessionData = [
            "date": ISO8601DateFormatter().string(from: date),
            "drills": drillsData,
            "total_completed_drills": totalCompleted,
            "total_drills": total
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: sessionData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📥 Backend response status: \(httpResponse.statusCode)")
        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Successfully synced completed session")
    }
    
    // MARK: - Drill Groups Sync
    
    func syncDrillGroup(name: String, description: String, drills: [DrillModel], isLikedGroup: Bool = false) async throws {
        print("ℹ️ Syncing drill group using DrillGroupService...")

        // Extract drill IDs from the models
        var drillIds: [Int] = []
        for drill in drills {
            if let backendId = drill.backendId {
                drillIds.append(backendId)
            } else {
                // Fallback to hash if no backendId is available
                let fallbackId = Int(drill.id.uuidString.hash) % 1000000
                drillIds.append(fallbackId)
                print("⚠️ Using fallback ID for drill: \(drill.title)")
            }
        }

        do {
            // Try to use the DrillGroupService
            if isLikedGroup {
                // For liked drills group, we should use the getLikedDrillsGroup endpoint first
                let likedGroup = try await DrillGroupService.shared.getLikedDrillsGroup()
                
                // Then update it with the current drills
                _ = try await DrillGroupService.shared.updateDrillGroupWithIds(
                    groupId: likedGroup.id,
                    name: name,
                    description: description,
                    drillIds: drillIds,
                    isLikedGroup: true
                )
            } else {
                // For regular groups, check if we need to create or update
                let existingGroups = try await DrillGroupService.shared.getAllDrillGroups()
                
                // Try to find a matching group by name
                if let existingGroup = existingGroups.first(where: { $0.name == name && !$0.isLikedGroup }) {
                    // Update the existing group
                    _ = try await DrillGroupService.shared.updateDrillGroupWithIds(
                        groupId: existingGroup.id,
                        name: name,
                        description: description,
                        drillIds: drillIds,
                        isLikedGroup: false
                    )
                } else {
                    // Create a new group
                    _ = try await DrillGroupService.shared.createDrillGroupWithIds(
                        name: name, 
                        description: description, 
                        drillIds: drillIds,
                        isLikedGroup: false
                    )
                }
            }
            
            print("✅ Successfully synced drill group using DrillGroupService")
        } catch {
            print("❌ Error syncing with DrillGroupService: \(error)")
            print("ℹ️ Falling back to legacy sync method...")
            
            // Fall back to original implementation
            let url = URL(string: "\(baseURL)/api/drills/groups/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Add auth token
            if let token = KeychainWrapper.standard.string(forKey: "authToken") {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            // Convert drills to dictionary format
            let drillsData = drills.map { drill in
                return [
                    "id": drill.id.uuidString,
                    "title": drill.title,
                    "skill": drill.skill,
                    "sets": drill.sets,
                    "reps": drill.reps,
                    "duration": drill.duration,
                    "description": drill.description,
                    "tips": drill.tips,
                    "equipment": drill.equipment,
                    "trainingStyle": drill.trainingStyle,
                    "difficulty": drill.difficulty
                ]
            }
            
            let groupData = [
                "name": name,
                "description": description,
                "drills": drillsData,
                "is_liked_group": isLikedGroup
            ] as [String : Any]
            
            request.httpBody = try JSONSerialization.data(withJSONObject: groupData)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NSError(domain: "DataSyncService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
            }
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                print("✅ Successfully synced drill group with legacy method")
                return
            } else {
//                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data)
//                let errorMessage = errorResponse?.detail ?? "Unknown error"
//                throw NSError(domain: "DataSyncService", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            }
        }
    }

    // TODO: might want to remove this and just do drillResponse object
    // Add a helper class for creating DrillResponse objects
    private struct MockDrillResponse: Codable {
        let id: Int
        let title: String
        let description: String
        let duration: Int
        let intensity: String
        let difficulty: String
        let equipment: [String]
        let suitableLocations: [String]
        let instructions: [String]
        let tips: [String]
        let type: String
        let sets: Int?
        let reps: Int?
        let rest: Int?
        
        // Convert to a DrillResponse
        func toDrillResponse() -> DrillResponse {
            return DrillResponse(
                id: self.id,
                title: self.title,
                description: self.description,
                duration: self.duration,
                intensity: self.intensity,
                difficulty: self.difficulty,
                equipment: self.equipment,
                suitableLocations: self.suitableLocations,
                instructions: self.instructions,
                tips: self.tips,
                type: self.type,
                sets: self.sets,
                reps: self.reps,
                rest: self.rest
            )
        }
    }
} 
