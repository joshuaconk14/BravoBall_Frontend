//
//  GroupModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 3/1/25.
//

import Foundation

// Group model
struct GroupModel: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var drills: [DrillModel]
}
