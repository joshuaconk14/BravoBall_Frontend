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
    
    // Drill for Sesison storage
    @Published var orderedDrills: [DrillModel] = []
    
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
    
    // Prerequisite options
    let timeOptions = ["15min", "30min", "45min", "1h", "1h30", "2h+"]
    let equipmentOptions = ["balls", "cones", "goals"]
    let trainingStyleOptions = ["medium intensity", "high intensity", "game prep", "game recovery", "rest day"]
    let locationOptions = ["field with goals", "small field", "indoor court"]
    let difficultyOptions = ["beginner", "intermediate", "advanced"]
    
    // Test data for drills with specific sub-skills
    static let testDrills: [DrillModel] = [
        DrillModel(
            title: "Short Passing Drill",
            sets: "4",
            reps: "10",
            duration: "15min",
            description: "Practice accurate short passes with a partner or wall.",
            tips: ["Keep the ball on the ground", "Use inside of foot", "Follow through towards target"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Long Passing Practice",
            sets: "3",
            reps: "8",
            duration: "20min",
            description: "Improve your long-range passing accuracy.",
            tips: ["Lock ankle", "Follow through", "Watch ball contact"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Through Ball Training",
            sets: "4",
            reps: "6",
            duration: "15min",
            description: "Practice timing and weight of through passes.",
            tips: ["Look for space", "Time the pass", "Weight it properly"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Power Shot Practice",
            sets: "3",
            reps: "5",
            duration: "20min",
            description: "Work on powerful shots on goal.",
            tips: ["Plant foot beside ball", "Strike with laces", "Follow through"],
            equipment: ["Soccer ball", "Goal"]
        ),
        DrillModel(
            title: "1v1 Dribbling Skills",
            sets: "4",
            reps: "8",
            duration: "15min",
            description: "Master close ball control and quick direction changes.",
            tips: ["Keep ball close", "Use both feet", "Change pace"],
            equipment: ["Soccer ball", "Cones"]
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
    
    // Update drills based on selected sub-skills
    func updateDrills() {
        if selectedSkills.isEmpty {
            orderedDrills = []
            return
        }
        
        
        // Show drills that match any of the selected sub-skills
        orderedDrills = Self.testDrills.filter { drill in
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
    }
    
    func moveDrill(from source: IndexSet, to destination: Int) {
        orderedDrills.move(fromOffsets: source, toOffset: destination)
    }
    
    func addDrillToGroup(drill: DrillModel, groupId: UUID) {
        if let index = savedDrills.firstIndex(where: { $0.id == groupId }) {
            // Modify the drills array of the group at the found index
            savedDrills[index].drills.append(drill)
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
    
    func generateSession() {
        // TODO: Implement session generation logic
    }
}

// Update DrillModel to be identifiable
struct DrillModel: Identifiable, Equatable {
    let id = UUID()
    var isLiked: Bool = false
    let title: String
    let sets: String
    let reps: String
    let duration: String
    let description: String
    let tips: [String]
    let equipment: [String]
    
    static func == (lhs: DrillModel, rhs: DrillModel) -> Bool {
        lhs.id == rhs.id
    }
}

// TODO: class for this later
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
