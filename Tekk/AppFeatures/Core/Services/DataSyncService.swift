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
        }
        
        // Create a mutable dictionary to build our preferences
        var preferences: [String: Any] = [
            "selected_equipment": Array(selectedEquipment),
            "current_streak": currentStreak,
            "highest_streak": highestStreak,
            "completed_sessions_count": completedSessionsCount
        ]
        
        // Add optional values only if they exist
        if let selectedTime = selectedTime {
            preferences["selected_time"] = selectedTime
        }
        if let selectedTrainingStyle = selectedTrainingStyle {
            preferences["selected_training_style"] = selectedTrainingStyle
        }
        if let selectedLocation = selectedLocation {
            preferences["selected_location"] = selectedLocation
        }
        if let selectedDifficulty = selectedDifficulty {
            preferences["selected_difficulty"] = selectedDifficulty
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: preferences)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Successfully synced user preferences")
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
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Successfully synced completed session")
    }
    
    // MARK: - Drill Groups Sync
    
    func syncDrillGroup(name: String, description: String, drills: [DrillModel], isLikedGroup: Bool = false) async throws {
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
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Successfully synced drill group")
    }
    
    func updateDrillGroup(groupId: Int, name: String?, description: String?, drills: [DrillModel]?, isLikedGroup: Bool?) async throws {
        let url = URL(string: "\(baseURL)/api/drills/groups/\(groupId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token
        if let token = KeychainWrapper.standard.string(forKey: "authToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        var groupData: [String: Any] = [:]
        
        if let name = name {
            groupData["name"] = name
        }
        if let description = description {
            groupData["description"] = description
        }
        if let drills = drills {
            groupData["drills"] = drills.map { drill in
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
        }
        if let isLikedGroup = isLikedGroup {
            groupData["is_liked_group"] = isLikedGroup
        }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: groupData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        print("✅ Successfully updated drill group")
    }
}
