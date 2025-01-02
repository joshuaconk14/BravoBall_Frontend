//
//  DrillModels.swift
//  BravoBall
//
//  Created by Jordan on 12/31/24.
//

import Foundation

// Struct for the drill recommendations
struct DrillRecommendation: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let duration: Int
    let difficulty: String
    let recommended_equipment: [String]
    let instructions: [String]
    let tips: [String]
    let video_url: String
    let matchScore: MatchScore
    
    // Struct for the match score, used to determine if the drill is a good fit for the user
    struct MatchScore: Codable {
        let skillLevelMatch: Bool
        let equipmentAvailable: Bool
        let recommendedForPosition: Bool
        let calculatedScore: Double
    }
}

// Struct for the response from the API
struct RecommendationsResponse: Codable {
    let status: String
    let message: String
    let access_token: String
    let token_type: String
    let recommendations: [DrillRecommendation]
    let metadata: Metadata

    struct Metadata: Codable {
        let totalDrills: Int
        let userSkillLevel: String
        let userPosition: String
        let availableEquipment: [String]
    }
}

// Class for storing and managing drill recommendations
class DrillsViewModel: ObservableObject {
    @Published var recommendedDrills: [DrillRecommendation] = []
    @Published var userEquipment: [String] = [] // List of equipment the user has
    static let shared = DrillsViewModel()
}