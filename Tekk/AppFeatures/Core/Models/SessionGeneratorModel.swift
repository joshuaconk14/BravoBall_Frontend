//
//  SessionGeneratorModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/31/25.
//

import Foundation
import SwiftKeychainWrapper

// MARK: Session model
class SessionGeneratorModel: ObservableObject {
    
    private let cacheManager = CacheManager.shared
    
    // FilterTypes
    @Published var selectedTime: String? {
        didSet { saveUserPreferences() }
    }
    @Published var selectedEquipment: Set<String> = [] {
        didSet { saveUserPreferences() }
    }
    @Published var selectedTrainingStyle: String? {
        didSet { saveUserPreferences() }
    }
    @Published var selectedLocation: String? {
        didSet { saveUserPreferences() }
    }
    @Published var selectedDifficulty: String? {
        didSet { saveUserPreferences() }
    }
    @Published var selectedSkills: Set<String> = [] {
        didSet {
            saveUserPreferences()
            updateDrills()
        }
    }

    // SessionGenerator Drills storage
    @Published var orderedSessionDrills: [EditableDrillModel] = [] {
        didSet { saveOrderedDrills() }
    }
    @Published var selectedDrills: [DrillModel] = []
    @Published var selectedDrillForEditing: EditableDrillModel?
    @Published var selectedRecommendedDrill: DrillModel?
    @Published var recommendedDrills: [DrillModel] = []
    
    // Saved Drills storage
    @Published var savedDrills: [GroupModel] = [] {
        didSet { saveSavedDrills() }
    }
    
    // Liked drills storage
    @Published var likedDrillsGroup: GroupModel = GroupModel(
        name: "Liked Drills",
        description: "Your favorite drills",
        drills: []
    ) {
        didSet { saveLikedDrills() }
    }
    
    // Saved filters storage
    @Published var allSavedFilters: [SavedFiltersModel] = []
    
    
    // Initialize with user's onboarding data
    init(onboardingData: OnboardingModel.OnboardingData) {
        loadCachedData()
        
        // Only set these values if they're not already loaded from cache
        if selectedDifficulty == nil {
            selectedDifficulty = onboardingData.trainingExperience.lowercased()
        }
        if selectedLocation == nil && !onboardingData.trainingLocation.isEmpty {
            selectedLocation = onboardingData.trainingLocation.first
        }
        if selectedEquipment.isEmpty {
            selectedEquipment = Set(onboardingData.availableEquipment)
        }
        if selectedTime == nil {
            switch onboardingData.dailyTrainingTime {
            case "Less than 15 minutes": selectedTime = "15min"
            case "15-30 minutes": selectedTime = "30min"
            case "30-60 minutes": selectedTime = "1h"
            case "1-2 hours": selectedTime = "1h30"
            case "More than 2 hours": selectedTime = "2h+"
            default: selectedTime = "1h"
            }
        }
    }
    
    
    
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
    func filterValue(for type: FilterType) -> String {
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
    
    
    
    
    
    
    
    
    // MARK: - Cache Operations
    
    // Public function to reload cache data after login
    func reloadUserData() {
        print("\n🔄 Reloading data for new user login...")
        // Clear current data first
        orderedSessionDrills = []
        savedDrills = []
        likedDrillsGroup = GroupModel(name: "Liked Drills", description: "Your favorite drills", drills: [])
        selectedDrills = []
        
        // Load fresh data from cache
        loadCachedData()
    }
    
    private func loadCachedData() {
        print("\n📱 Loading cached data for current user...")
        let userEmail = KeychainWrapper.standard.string(forKey: "userEmail") ?? "no user"
        print("\n👤 USER SESSION INFO:")
        print("----------------------------------------")
        print("Current user email: \(userEmail)")
        print("Cache key being used: \(CacheKey.orderedDrills.forUser(userEmail))")
        print("----------------------------------------")
        
        // Load ordered drills
        if let drills: [EditableDrillModel] = cacheManager.retrieve(forKey: .orderedDrills) {
            print("\n📋 ORDERED DRILLS FOR USER \(userEmail):")
            print("----------------------------------------")
            print("Number of drills found: \(drills.count)")
            print("Drill titles:")
            drills.enumerated().forEach { index, drill in
                print("  \(index + 1). \(drill.drill.title) (Completed: \(drill.isCompleted))")
            }
            print("----------------------------------------")
            orderedSessionDrills = drills
        } else {
            print("\n📋 ORDERED DRILLS FOR USER \(userEmail):")
            print("----------------------------------------")
            print("No drills found in cache")
            print("----------------------------------------")
        }
        
        // Load user preferences
        if let preferences: UserPreferences = cacheManager.retrieve(forKey: .userPreferences) {
            selectedTime = preferences.time
            selectedEquipment = preferences.equipment
            selectedTrainingStyle = preferences.trainingStyle
            selectedLocation = preferences.location
            selectedDifficulty = preferences.difficulty
            selectedSkills = preferences.skills
            print("✅ Successfully loaded user preferences from cache")
        } else {
            print("ℹ️ No user preferences found in cache")
        }
        
        // Load saved drills
        if let drills: [GroupModel] = cacheManager.retrieve(forKey: .savedDrills) {
            savedDrills = drills
            print("✅ Successfully loaded saved drills from cache")
        } else {
            print("ℹ️ No saved drills found in cache")
        }
        
        // Load liked drills
        if let liked: GroupModel = cacheManager.retrieve(forKey: .likedDrills) {
            likedDrillsGroup = liked
            print("✅ Successfully loaded liked drills from cache")
        } else {
            print("ℹ️ No liked drills found in cache")
        }
    }
    
    private func saveUserPreferences() {
        let preferences = UserPreferences(
            time: selectedTime,
            equipment: selectedEquipment,
            trainingStyle: selectedTrainingStyle,
            location: selectedLocation,
            difficulty: selectedDifficulty,
            skills: selectedSkills
        )
        cacheManager.cache(preferences, forKey: .userPreferences)
    }
    
    // cache updated changes
    private func saveOrderedDrills() {
        print("\n💾 Saving ordered drills to cache...")
        print("Number of drills to save: \(orderedSessionDrills.count)")
        cacheManager.cache(orderedSessionDrills, forKey: .orderedDrills)
    }
    
    // cache updated changes
    private func saveSavedDrills() {
        cacheManager.cache(savedDrills, forKey: .savedDrills)
    }
    
    // cache updated changes
    private func saveLikedDrills() {
        cacheManager.cache(likedDrillsGroup, forKey: .likedDrills)
    }
    
    // MARK: - Cache Testing
    func testCacheOperations() {
        print("\n🧪 Starting cache tests...")
        
        // Test 1: Test ordered drills caching
        print("\n📝 Test 1: Testing ordered drills caching")
        
        // Create some test drills
        let testDrill = EditableDrillModel(
            drill: DrillModel(
                title: "Test Drill",
                skill: "Testing",
                sets: 3,
                reps: 10,
                duration: 15,
                description: "Test description",
                tips: ["Tip 1", "Tip 2"],
                equipment: ["Test equipment"],
                trainingStyle: "Test style",
                difficulty: "Beginner"
            ),
            setsDone: 0,
            totalSets: 3,
            totalReps: 10,
            totalDuration: 15,
            isCompleted: false
        )
        
        // Print current user
        let userEmail = KeychainWrapper.standard.string(forKey: "userEmail") ?? "no user"
        print("\n👤 Current user: \(userEmail)")
        
        // Save test drills
        orderedSessionDrills = [testDrill]
        print("Saving drill: \(testDrill.drill.title)")
        saveOrderedDrills()
        
        // Clear memory
        orderedSessionDrills = []
        print("Cleared orderedSessionDrills from memory")
        
        // Load from cache
        loadCachedData()
        
        // Verify
        if !orderedSessionDrills.isEmpty {
            print("✅ Successfully retrieved ordered drills from cache")
            print("Number of drills: \(orderedSessionDrills.count)")
            print("First drill title: \(orderedSessionDrills[0].drill.title)")
            
            // Verify the drill data is correct
            let retrievedDrill = orderedSessionDrills[0]
            if retrievedDrill == testDrill {
                print("✅ Retrieved drill matches saved drill")
            } else {
                print("❌ Retrieved drill does not match saved drill")
                print("Original drill: \(testDrill)")
                print("Retrieved drill: \(retrievedDrill)")
            }
        } else {
            print("❌ Failed to retrieve ordered drills from cache")
        }
        
        // Test 2: Clear cache and verify it's cleared
        print("\n📝 Test 2: Testing cache clearing")
        cacheManager.clearCache(forKey: .orderedDrills)
        
        // Verify it's cleared
        orderedSessionDrills = []
        loadCachedData()
        if orderedSessionDrills.isEmpty {
            print("✅ Cache successfully cleared")
        } else {
            print("❌ Cache not cleared properly")
        }
        
        print("\n🧪 Cache tests completed!")
    }
    
}

// MARK: - Helper Structs
    
private struct UserPreferences: Codable {
    let time: String?
    let equipment: Set<String>
    let trainingStyle: String?
    let location: String?
    let difficulty: String?
    let skills: Set<String>
}


