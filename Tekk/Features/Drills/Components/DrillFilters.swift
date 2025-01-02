//
//  DrillFilters.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation

struct DrillFilters {
    var difficulty: String?
    var equipment: Set<String> = []
    
    init(difficulty: String? = nil, equipment: Set<String> = []) {
        self.difficulty = difficulty
        self.equipment = equipment
    }
}

