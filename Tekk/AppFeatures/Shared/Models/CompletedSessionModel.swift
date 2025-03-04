//
//  CompletedSessionModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/1/25.
//

import Foundation


struct CompletedSession: Codable {
    let id: UUID
    let date: Date
    let drills: [EditableDrillModel]
    let totalCompletedDrills: Int
    let totalDrills: Int
    
    init(id: UUID = UUID(),
         date: Date,
         drills: [EditableDrillModel],
         totalCompletedDrills: Int,
         totalDrills: Int) {
        self.id = id
        self.date = date
        self.drills = drills
        self.totalCompletedDrills = totalCompletedDrills
        self.totalDrills = totalDrills
    }
}
