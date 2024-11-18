//
//  ProgramModels.swift
//  BravoBall
//
//  Created by Jordan on 11/12/24.
//

import Foundation

// Program Models
struct Program: Codable {
    let weeks: [Week]
    let difficulty: String
    let focusAreas: [String]
    
    enum CodingKeys: String, CodingKey {
        case weeks
        case difficulty
        case focusAreas = "focus_areas"
    }
}

struct Week: Codable, Identifiable {
    let id = UUID()
    let weekNumber: Int
    let theme: String
    let description: String
    let drills: [Drill]

    // Coding keys for decoding JSON data from backend API response
    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case theme
        case description
        case drills
    }
}

struct Drill: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let duration: Int
    let type: String
    let difficulty: String
    let equipment: [String]
    let instructions: [String]
    let tips: [String]
    let videoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case title, description, duration, type, difficulty, equipment, instructions, tips
        case videoUrl = "video_url"
    }
}
