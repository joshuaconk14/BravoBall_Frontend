//
//  SessionGeneratorModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/31/25.
//

import Foundation

// MARK: Session model
class SessionGeneratorModel: ObservableObject {
    @Published var selectedTime: String?
    @Published var selectedEquipment: Set<String> = []
    @Published var selectedTrainingStyle: String?
    @Published var selectedLocation: String?
    @Published var selectedDifficulty: String?
    @Published var selectedSkills: Set<String> = [] {
        didSet {
            updateDrills()
        }
    }
    // Reference to the drill we want to edit
    @Published var selectedDrillForEditing: EditableDrillModel?
    
    @Published var recommendedDrills: [DrillModel] = []
    
    // Drill for Session storage
    // TODO: see if having too much arrays takes too much storage and if its easier to give isSelected Bool to drills
    @Published var selectedDrills: [DrillModel] = []
    @Published var orderedSessionDrills: [EditableDrillModel] = []
    
    // Saved Drill storage
    @Published var savedDrills: [GroupModel] = []
    
    // Liked drills storage
    @Published var likedDrillsGroup: GroupModel = GroupModel(
        name: "Liked Drills",
        description: "Your favorite drills",
        drills: []
    )
    
    // TODO: make new class for filters
    // Saved filters storage
    @Published var allSavedFilters: [SavedFiltersModel] = []
    
    // Filter options
    let timeOptions = ["15min", "30min", "45min", "1h", "1h30", "2h+"]
    let equipmentOptions = ["balls", "cones", "goals"]
    let trainingStyleOptions = ["medium intensity", "high intensity", "game prep", "game recovery", "rest day"]
    let locationOptions = ["field with goals", "small field", "indoor court"]
    let difficultyOptions = ["beginner", "intermediate", "advanced"]
    
    // Test data for drills with specific sub-skills
    static let testDrills: [DrillModel] = [
        DrillModel(
            title: "Short Passing Drill",
            skill: "Passing",
            sets: 4,
            reps: 10,
            duration: 15,
            description: "Practice accurate short passes with a partner or wall.",
            tips: ["Keep the ball on the ground", "Use inside of foot", "Follow through towards target"],
            equipment: ["Soccer ball", "Cones"],
            trainingStyle: "High Intensity",
            difficulty: "Beginner"
        ),
        DrillModel(
            title: "Long Passing Practice",
            skill: "Passing",
            sets: 3,
            reps: 8,
            duration: 20,
            description: "Improve your long-range passing accuracy.",
            tips: ["Lock ankle", "Follow through", "Watch ball contact"],
            equipment: ["Soccer ball", "Cones"],
            trainingStyle: "Medium Intensity",
            difficulty: "Intermediate"
        ),
        DrillModel(
            title: "Through Ball Training",
            skill: "Passing",
            sets: 4,
            reps: 6,
            duration: 15,
            description: "Practice timing and weight of through passes.",
            tips: ["Look for space", "Time the pass", "Weight it properly"],
            equipment: ["Soccer ball", "Cones"],
            trainingStyle: "Medium Intensity",
            difficulty: "Intermediate"
        ),
        DrillModel(
            title: "Power Shot Practice",
            skill: "Shooting",
            sets: 3,
            reps: 5,
            duration: 20,
            description: "Work on powerful shots on goal.",
            tips: ["Plant foot beside ball", "Strike with laces", "Follow through"],
            equipment: ["Soccer ball", "Goal"],
            trainingStyle: "High Intensity",
            difficulty: "Intermediate"
        ),
        DrillModel(
            title: "1v1 Dribbling Skills",
            skill: "Dribbling",
            sets: 4,
            reps: 8,
            duration: 15,
            description: "Master close ball control and quick direction changes.",
            tips: ["Keep ball close", "Use both feet", "Change pace"],
            equipment: ["Soccer ball", "Cones"],
            trainingStyle: "High Intensity",
            difficulty: "Intermediate"
        )
    ]
    
    
    
    // Initialize with user's onboarding data
    init(onboardingData: OnboardingModel.OnboardingData) {
        selectedDifficulty = onboardingData.trainingExperience.lowercased()
        if let location = onboardingData.trainingLocation.first {
            selectedLocation = location
        }
        selectedEquipment = Set(onboardingData.availableEquipment)
        
        switch onboardingData.dailyTrainingTime {
        case "Less than 15 minutes": selectedTime = "15min"
        case "15-30 minutes": selectedTime = "30min"
        case "30-60 minutes": selectedTime = "1h"
        case "1-2 hours": selectedTime = "1h30"
        case "More than 2 hours": selectedTime = "2h+"
        default: selectedTime = "1h"
        }
    }
    
    // Update drills based on selected sub-skills, converting testDrill's DrillModels into orderedDrill's EditDrillModels
    func updateDrills() {
        if selectedSkills.isEmpty {
            orderedSessionDrills = []
            return
        }
        
        
        // Show drills that match any of the selected sub-skills
        let filteredDrills = Self.testDrills.filter { drill in
            // Check if any of the selected skills match the drill
            for skill in selectedSkills {
                // Match drills based on skill keywords
                switch skill.lowercased() {
                case "short passing":
                    if drill.title.contains("Short Passing") { return true }
                case "long passing":
                    if drill.title.contains("Long Passing") { return true }
                case "through balls":
                    if drill.title.contains("Through Ball") { return true }
                case "power shots", "finesse shots", "volleys", "one-on-one finishing", "long shots":
                    if drill.title.contains("Shot") || drill.title.contains("Shooting") { return true }
                case "close control", "speed dribbling", "1v1 moves", "winger skills", "ball mastery":
                    if drill.title.contains("Dribbling") || drill.title.contains("1v1") { return true }
                default:
                    // For any other skills, try to match based on the first word
                    let mainSkill = skill.split(separator: " ").first?.lowercased() ?? ""
                    if drill.title.lowercased().contains(mainSkill) { return true }
                }
            }
            return false
        }
        // Convert filtered DrillModels to EditableDrillModels
        orderedSessionDrills = filteredDrills.map { drill in
            EditableDrillModel(
                drill: drill,
                setsDone: 0,
                totalSets: drill.sets,
                totalReps: drill.reps,
                totalDuration: drill.duration,
                isCompleted: false
            )
        }
    }
    
    func sessionNotComplete() -> Bool {
        orderedSessionDrills.contains(where: { $0.isCompleted == false })
    }
    
    func sessionsLeftToComplete() -> Int {
//        let sessionsLeft = orderedSessionDrills.count(where: {$0.isCompleted == false})
//            return String(sessionsLeft)
        orderedSessionDrills.count(where: {$0.isCompleted == false})
        
    }
    
    func clearOrderedDrills() {
        orderedSessionDrills.removeAll()
    }
    
    func moveDrill(from source: IndexSet, to destination: Int) {
        orderedSessionDrills.move(fromOffsets: source, toOffset: destination)
    }
    
    func addDrillToGroup(drill: DrillModel, groupId: UUID) {
        if let index = savedDrills.firstIndex(where: { $0.id == groupId }) {
            // Modify the drills array of the group at the found index
            savedDrills[index].drills.append(drill)
        }
    }
    
    func removeDrillFromGroup(drill: DrillModel, groupId: UUID) {
        if let index = savedDrills.firstIndex(where: { $0.id == groupId }) {
            // Modify the drills array of the group at the found index
            savedDrills[index].drills.removeAll(where: { $0.id == drill.id })
        }
    }
    
    func createGroup(name: String, description: String) {
        let groupModel = GroupModel(
            name: name,
            description: description,
            drills: []
        )
        
        savedDrills.append(groupModel)
    }
    
    func toggleDrillLike(drillId: UUID, drill: DrillModel) {
        if likedDrillsGroup.drills.contains(drill) {
            likedDrillsGroup.drills.removeAll(where: { $0.id == drillId })
        } else {
            likedDrillsGroup.drills.append(drill)
        }
    }
    
    func isDrillLiked(_ drill: DrillModel) -> Bool {
        likedDrillsGroup.drills.contains(drill)
    }

    // Selected drills to add to session
    func drillsToAdd (drill: DrillModel) {
        if selectedDrills.contains(drill) {
            selectedDrills.removeAll(where: { $0.id == drill.id })
        } else {
            selectedDrills.append(drill)
        }
    }
    
    func isDrillSelected(_ drill: DrillModel) -> Bool {
        selectedDrills.contains(drill)
    }
    
    // Adding drills to session
    func addDrillToSession(drills: [DrillModel]) {
        for oneDrill in drills {
            let editableDrills = EditableDrillModel(
                drill: oneDrill,
                setsDone: 0,
                totalSets: oneDrill.sets,
                totalReps: oneDrill.reps,
                totalDuration: oneDrill.duration,
                isCompleted: false
            )
            if !orderedSessionDrills.contains(where: {$0.drill.id == oneDrill.id}) {
                orderedSessionDrills.append(editableDrills)
            }
            
        }
        
        if !selectedDrills.isEmpty {
            selectedDrills.removeAll()
        }
    }
    
    // Deleting drills from session
    func deleteDrillFromSession(drill: EditableDrillModel) {
        orderedSessionDrills.removeAll(where: { $0.drill.id == drill.drill.id })
    }
    
    // Filter value that is selected, or if its empty
    func filterValue(for type: MainAppModel.FilterType) -> String {
        switch type {
        case .time:
            return selectedTime ?? ""
        case .equipment:
            return selectedEquipment.isEmpty ? "" : "\(selectedEquipment.count) selected"
        case .trainingStyle:
            return selectedTrainingStyle ?? ""
        case .location:
            return selectedLocation ?? ""
        case .difficulty:
            return selectedDifficulty ?? ""
        }
    }
    
    // Save filters into saved filters group
    func saveFiltersInGroup(name: String) {
        
        guard !name.isEmpty else { return }
        
        let savedFilters = SavedFiltersModel(
            name: name,
            savedTime: selectedTime,
            savedEquipment: selectedEquipment,
            savedTrainingStyle: selectedTrainingStyle,
            savedLocation: selectedLocation,
            savedDifficulty: selectedDifficulty
        )
        
        allSavedFilters.append(savedFilters)
    }
    
    // Load filter after clicking the name of saved filter
    func loadFilter(_ filter: SavedFiltersModel) {
        selectedTime = filter.savedTime
        selectedEquipment = filter.savedEquipment
        selectedTrainingStyle = filter.savedTrainingStyle
        selectedLocation = filter.savedLocation
        selectedDifficulty = filter.savedDifficulty
    }
    
}

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
         sets: Int,
         reps: Int,
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



struct EditableDrillModel: Codable {
    var drill: DrillModel
    var setsDone: Int
    var totalSets: Int
    var totalReps: Int
    var totalDuration: Int
    var isCompleted: Bool
}

// Group model
struct GroupModel: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var drills: [DrillModel]
}

struct SkillCategory {
    let name: String
    let subSkills: [String]
    let icon: String
}

struct SavedFiltersModel: Codable {
    let name: String
    let savedTime: String?
    let savedEquipment: Set<String>
    let savedTrainingStyle: String?
    let savedLocation: String?
    let savedDifficulty: String?
}


extension SessionGeneratorView {
    // Define all available skill categories and their sub-skills
    static let skillCategories: [SkillCategory] = [
        SkillCategory(name: "Passing", subSkills: [
            "Short passing",
            "Long passing",
            "Through balls",
            "First-time passing",
            "Wall passing"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Shooting", subSkills: [
            "Power shots",
            "Finesse shots",
            "Volleys",
            "One-on-one finishing",
            "Long shots"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Dribbling", subSkills: [
            "Close control",
            "Speed dribbling",
            "1v1 moves",
            "Winger skills",
            "Ball mastery"
        ], icon: "figure.walk"),
        
        SkillCategory(name: "First Touch", subSkills: [
            "Ground control",
            "Aerial control",
            "Turn with ball",
            "Receiving under pressure",
            "One-touch control"
        ], icon: "figure.stand"),
        
        SkillCategory(name: "Defending", subSkills: [
            "1v1 defending",
            "Tackling",
            "Positioning",
            "Intercepting",
            "Pressing"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Fitness", subSkills: [
            "Speed",
            "Agility",
            "Endurance",
            "Strength",
            "Recovery"
        ], icon: "figure.run")
    ]
}
