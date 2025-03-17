//
//  DrillModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import Foundation

// Drill model
struct DrillModel: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let skill: String
    let sets: Int
    let reps: Int
    let duration: Int
    let description: String
    let tips: [String]
    let equipment: [String]
    let trainingStyle: String
    let difficulty: String
    
    init(id: UUID = UUID(),  // Adding initializer with default UUID
         title: String,
         skill: String,
         sets: Int = 0,  // Make sets optional with default value of 0
         reps: Int = 0,  // Make reps optional with default value of 0
         duration: Int,
         description: String,
         tips: [String],
         equipment: [String],
         trainingStyle: String,
         difficulty: String) {
        self.id = id
        self.title = title
        self.skill = skill
        self.sets = sets
        self.reps = reps
        self.duration = duration
        self.description = description
        self.tips = tips
        self.equipment = equipment
        self.trainingStyle = trainingStyle
        self.difficulty = difficulty
    }
    
    static func == (lhs: DrillModel, rhs: DrillModel) -> Bool {
        lhs.id == rhs.id
    }
}
