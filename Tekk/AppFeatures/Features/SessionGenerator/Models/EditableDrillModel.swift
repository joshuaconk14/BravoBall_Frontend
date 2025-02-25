//
//  EditableDrillModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import Foundation

struct EditableDrillModel: Codable {
    var drill: DrillModel
    var setsDone: Int
    var totalSets: Int
    var totalReps: Int
    var totalDuration: Int
    var isCompleted: Bool
}

