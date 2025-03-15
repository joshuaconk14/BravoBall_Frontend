//
//  FilterTypes.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/24/25.
//

import SwiftUI
import RiveRuntime


enum FilterType: String, CaseIterable, Identifiable {
    case time = "Time"
    case equipment = "Equipment"
    case trainingStyle = "Training Style"
    case location = "Location"
    case difficulty = "Difficulty"
    
    var id: String { rawValue }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .time:
            RiveViewModel(fileName: "Prereq_Time").view()
                .frame(width: 30, height: 30)
        case .equipment:
            RiveViewModel(fileName: "Prereq_Equipment").view()
                .frame(width: 30, height: 30)
        case .trainingStyle:
            RiveViewModel(fileName: "Prereq_Training_Style").view()
                .frame(width: 30, height: 30)
        case .location:
            RiveViewModel(fileName: "Prereq_Location").view()
                .frame(width: 30, height: 30)
        case .difficulty:
            RiveViewModel(fileName: "Prereq_Difficulty").view()
                .frame(width: 30, height: 30)
        }
    }
}

enum FilterIcon {
    case time
    case equipment
    case trainingStyle
    case location
    case difficulty
    
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .time:
            RiveViewModel(fileName: "Prereq_Time").view()
                .frame(width: 30, height: 30)
        case .equipment:
            RiveViewModel(fileName: "Prereq_Equipment").view()
                .frame(width: 30, height: 30)
        case .trainingStyle:
            RiveViewModel(fileName: "Prereq_Training_Style").view()
                .frame(width: 30, height: 30)
        case .location:
            RiveViewModel(fileName: "Prereq_Location").view()
                .frame(width: 30, height: 30)
        case .difficulty:
            RiveViewModel(fileName: "Prereq_Difficulty").view()
                .frame(width: 30, height: 30)
        }
    }
}


// TODO: will need more for recovery, etc
enum TrainingStyleType: String, CaseIterable {
    case medium = "Medium"
    case high = "High"
}

enum DifficultyType: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}


enum FilterData {
    // Filter options
    static let timeOptions = ["15min", "30min", "45min", "1h", "1h30", "2h+"]
    static let equipmentOptions = ["balls", "cones", "goals"]
    static let trainingStyleOptions = ["medium intensity", "high intensity", "game prep", "game recovery", "rest day"]
    static let locationOptions = ["field with goals", "small field", "indoor court"]
    static let difficultyOptions = ["beginner", "intermediate", "advanced"]
}

struct SavedFiltersModel: Codable, Identifiable {
    let id: UUID
    let name: String
    let savedTime: String?
    let savedEquipment: Set<String>
    let savedTrainingStyle: String?
    let savedLocation: String?
    let savedDifficulty: String?
    
    init(name: String, savedTime: String?, savedEquipment: Set<String>, savedTrainingStyle: String?, savedLocation: String?, savedDifficulty: String?) {
        self.id = UUID()
        self.name = name
        self.savedTime = savedTime
        self.savedEquipment = savedEquipment
        self.savedTrainingStyle = savedTrainingStyle
        self.savedLocation = savedLocation
        self.savedDifficulty = savedDifficulty
    }
}
