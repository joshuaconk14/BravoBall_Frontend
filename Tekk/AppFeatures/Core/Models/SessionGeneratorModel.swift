//
//  SessionGeneratorModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/31/25.
//


import SwiftUI
import Foundation
import SwiftKeychainWrapper

// MARK: Session model
class SessionGeneratorModel: ObservableObject {
    
    @ObservedObject var appModel: MainAppModel  // Add this
        
    
    
    // Define Preferences struct for caching
    private struct Preferences: Codable {
        var selectedTime: String?
        var selectedEquipment: [String]
        var selectedTrainingStyle: String?
        var selectedLocation: String?
        var selectedDifficulty: String?
        
        init(from model: SessionGeneratorModel) {
            self.selectedTime = model.selectedTime
            self.selectedEquipment = Array(model.selectedEquipment)
            self.selectedTrainingStyle = model.selectedTrainingStyle
            self.selectedLocation = model.selectedLocation
            self.selectedDifficulty = model.selectedDifficulty
        }
    }
    
    private let cacheManager = CacheManager.shared
    private var lastSyncTime: Date = Date()
    private let syncDebounceInterval: TimeInterval = 2.0 // 2 seconds
    private var hasUnsavedChanges = false
    private var autoSaveTimer: Timer?
    
    // FilterTypes
    @Published var selectedTime: String? {
        didSet { markAsNeedingSave() }
    }
    @Published var selectedEquipment: Set<String> = [] {
        didSet { markAsNeedingSave() }
    }
    @Published var selectedTrainingStyle: String? {
        didSet { markAsNeedingSave() }
    }
    @Published var selectedLocation: String? {
        didSet { markAsNeedingSave() }
    }
    @Published var selectedDifficulty: String? {
        didSet { markAsNeedingSave() }
    }
    @Published var selectedSkills: Set<String> = [] {
        didSet {
            updateDrills()
        }
    }
    @Published var selectedDrills: [DrillModel] = []
    @Published var selectedDrillForEditing: EditableDrillModel?
    @Published var recommendedDrills: [DrillModel] = []
    
    
    
    // MARK: Cached Data
    // SessionGenerator Drills storage
    @Published var orderedSessionDrills: [EditableDrillModel] = [] {
        didSet { cacheOrderedDrills() }
    }
    // Saved Drills storage
    @Published var savedDrills: [GroupModel] = [] {
        didSet { cacheSavedDrills() }
    }
    
    // Liked drills storage
    @Published var likedDrillsGroup: GroupModel = GroupModel(
        name: "Liked Drills",
        description: "Your favorite drills",
        drills: []
    ) {
        didSet { cacheLikedDrills() }
    }
    
    // Saved filters storage
    @Published var allSavedFilters: [SavedFiltersModel] = []
    // didset in saved filters func
    
    
    
    
    
    // Initialize with user's onboarding data
    init(appModel: MainAppModel, onboardingData: OnboardingModel.OnboardingData) {
        self.appModel = appModel
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
        
        // Setup auto-save timer
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.saveIfNeeded()
        }
    }
    
    deinit {
        autoSaveTimer?.invalidate()
        saveIfNeeded() // Final save on deinit
    }
    
    private func markAsNeedingSave() {
        hasUnsavedChanges = true
        
        // Create and cache preferences
        let preferences = Preferences(from: self)
        cacheManager.cache(preferences, forKey: .filterGroupsCase)
    }
    
    func saveIfNeeded() {
        guard hasUnsavedChanges else { return }
        
        Task {
            do {
                try await DataSyncService.shared.syncUserPreferences(
                    selectedTime: selectedTime,
                    selectedEquipment: selectedEquipment,
                    selectedTrainingStyle: selectedTrainingStyle,
                    selectedLocation: selectedLocation,
                    selectedDifficulty: selectedDifficulty,
                    currentStreak: appModel.currentStreak,
                    highestStreak: appModel.highestStreak,
                    completedSessionsCount: appModel.countOfFullyCompletedSessions
                )
                await MainActor.run {
                    hasUnsavedChanges = false
                }
            } catch {
                print("❌ Error syncing preferences: \(error)")
            }
        }
    }
    
    // Call this when view disappears or app goes to background
    func saveChanges() {
        saveIfNeeded()
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
        // Only update drills if the array is empty
        if orderedSessionDrills.isEmpty {
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
            
            // Cache the drills
            cacheOrderedDrills()
            print("✅ Updated drills based on selected skills: \(selectedSkills)")
        } else {
            print("ℹ️ Skipping drill update as drills are already loaded")
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
    
    // MARK: - Group Management Methods
    
    // Add a property to track backend IDs for each group
    private var groupBackendIds: [UUID: Int] = [:]
    
    // Add a property to track the backend ID for the liked group
    private var likedGroupBackendId: Int?
    
    // Updated method to add drill to group
    func addDrillToGroup(drill: DrillModel, groupId: UUID) {
        if let index = savedDrills.firstIndex(where: { $0.id == groupId }) {
            // Add drill to local model
            if !savedDrills[index].drills.contains(drill) {
                savedDrills[index].drills.append(drill)
            }
            
            // Add to backend if we have a backend ID
            if let backendId = groupBackendIds[groupId] {
                Task {
                    do {
                        if let drillBackendId = drill.backendId {
                            _ = try await DrillGroupService.shared.addDrillToGroup(groupId: backendId, drillId: drillBackendId)
                            print("✅ Successfully added drill to group on backend")
                        } else {
                            print("⚠️ No backend ID available for drill: \(drill.title)")
                        }
                    } catch {
                        print("❌ Error adding drill to group on backend: \(error)")
                    }
                }
            }
        }
    }
    
    // Updated method to remove drill from group
    func removeDrillFromGroup(drill: DrillModel, groupId: UUID) {
        if let index = savedDrills.firstIndex(where: { $0.id == groupId }) {
            // Remove drill from local model
            savedDrills[index].drills.removeAll(where: { $0.id == drill.id })
            
            // Remove from backend if we have a backend ID
            if let backendId = groupBackendIds[groupId] {
                Task {
                    do {
                        if let drillBackendId = drill.backendId {
                            _ = try await DrillGroupService.shared.removeDrillFromGroup(groupId: backendId, drillId: drillBackendId)
                            print("✅ Successfully removed drill from group on backend")
                        } else {
                            print("⚠️ No backend ID available for drill: \(drill.title)")
                        }
                    } catch {
                        print("❌ Error removing drill from group on backend: \(error)")
                    }
                }
            }
        }
    }
    
    // Updated method to create a group
    func createGroup(name: String, description: String) {
        let groupModel = GroupModel(
            name: name,
            description: description,
            drills: []
        )
        
        // Add to local model
        savedDrills.append(groupModel)
        
        // Create on backend
        Task {
            do {
                let response = try await DrillGroupService.shared.createDrillGroupWithIds(
                    name: name, 
                    description: description,
                    drillIds: [], // Empty array for new group
                    isLikedGroup: false
                )
                // Store the backend ID
                groupBackendIds[groupModel.id] = response.id
                print("✅ Successfully created group on backend with ID: \(response.id)")
            } catch {
                print("❌ Error creating group on backend: \(error)")
            }
        }
    }
    
    // Add a method to delete a group
    func deleteGroup(groupId: UUID) {
        // Remove from local model
        savedDrills.removeAll(where: { $0.id == groupId })
        
        // Delete from backend if we have a backend ID
        if let backendId = groupBackendIds[groupId] {
            Task {
                do {
                    _ = try await DrillGroupService.shared.deleteDrillGroup(groupId: backendId)
                    // Remove the stored backend ID
                    groupBackendIds.removeValue(forKey: groupId)
                    print("✅ Successfully deleted group from backend")
                } catch {
                    print("❌ Error deleting group from backend: \(error)")
                }
            }
        }
    }
    
    // Updated method for toggling drill likes
    func toggleDrillLike(drillId: UUID, drill: DrillModel) {
        if likedDrillsGroup.drills.contains(drill) {
            likedDrillsGroup.drills.removeAll(where: { $0.id == drillId })
        } else {
            likedDrillsGroup.drills.append(drill)
        }
        
        // Toggle on backend
        Task {
            do {
                if let backendDrillId = drill.backendId {
                    let response = try await DrillGroupService.shared.toggleDrillLike(drillId: backendDrillId)
                    print("✅ Successfully toggled drill like on backend: \(response.message)")
                } else {
                    print("⚠️ No backend ID available for drill: \(drill.title)")
                }
            } catch {
                print("❌ Error toggling drill like on backend: \(error)")
            }
        }
    }
    
    // Updated method to check if a drill is liked
    func isDrillLiked(_ drill: DrillModel) -> Bool {
        return likedDrillsGroup.drills.contains(drill)
    }
    
    // Add a method to check with the backend if a drill is liked
    func checkDrillLikedStatus(drillId: Int) async -> Bool {
        do {
            return try await DrillGroupService.shared.checkDrillLiked(drillId: drillId)
        } catch {
            print("❌ Error checking drill liked status: \(error)")
            // Fall back to local state, using backendId if available
            return likedDrillsGroup.drills.contains(where: { $0.backendId == drillId })
        }
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
        let value = switch type {
        case .time:
            selectedTime ?? ""
        case .equipment:
            selectedEquipment.isEmpty ? "" : "\(selectedEquipment.count) selected"
        case .trainingStyle:
            selectedTrainingStyle ?? ""
        case .location:
            selectedLocation ?? ""
        case .difficulty:
            selectedDifficulty ?? ""
        }
        
        return value
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
        
        cacheFilterGroups(name: name)
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
    
    // Clear all user data when logging out
    func clearUserData() {
        print("\n🧹 Clearing user data...")
        // Clear all published properties
        orderedSessionDrills = []
        savedDrills = []
        likedDrillsGroup = GroupModel(name: "Liked Drills", description: "Your favorite drills", drills: [])
        selectedDrills = []
        allSavedFilters = []
        
        // Clear filter preferences
        selectedTime = nil
        selectedEquipment = []
        selectedTrainingStyle = nil
        selectedLocation = nil
        selectedDifficulty = nil
        selectedSkills = []
        
        print("✅ User data cleared successfully")
    }
    
    
    // Displaying cached data for specific user based off email in keychain
    func loadCachedData() {
        print("\n📱 Loading cached data for current user...")
        let userEmail = KeychainWrapper.standard.string(forKey: "userEmail") ?? "no user"
        print("\n👤 USER SESSION INFO:")
        print("----------------------------------------")
        print("Current user email: \(userEmail)")
        print("Cache key being used: \(CacheKey.orderedDrillsCase.forUser(userEmail))")
        print("----------------------------------------")
        
        // Load preferences
        if let preferences: Preferences = cacheManager.retrieve(forKey: .filterGroupsCase) {
            selectedTime = preferences.selectedTime
            selectedEquipment = Set(preferences.selectedEquipment)
            selectedTrainingStyle = preferences.selectedTrainingStyle
            selectedLocation = preferences.selectedLocation
            selectedDifficulty = preferences.selectedDifficulty
            print("✅ Successfully loaded preferences from cache")
        }
        
        // Load ordered drills
        if let drills: [EditableDrillModel] = cacheManager.retrieve(forKey: .orderedDrillsCase) {
            print("\n📋 ORDERED DRILLS FOR USER \(userEmail):")
            print("----------------------------------------")
            print("Number of drills found: \(drills.count)")
            print("Drill titles:")
            drills.enumerated().forEach { index, drill in
                print("  \(index + 1). \(drill.drill.title) (Completed: \(drill.isCompleted))")
            }
            print("----------------------------------------")
            orderedSessionDrills = drills
            
            // Ensure we don't override these drills with default ones
            if !drills.isEmpty {
                print("✅ Using cached drills instead of default drills")
                
                // Extract skills from the loaded drills
                let drillSkills = Set(drills.map { $0.drill.skill })
                print("📊 Skills from cached drills: \(drillSkills)")
                
                // Update selected skills based on the loaded drills
                if selectedSkills.isEmpty {
                    selectedSkills = drillSkills
                    print("✅ Updated selected skills from cached drills: \(selectedSkills)")
                }
            }
        } else {
            print("\n📋 ORDERED DRILLS FOR USER \(userEmail):")
            print("----------------------------------------")
            print("ℹ️No drills found in cache")
            print("----------------------------------------")
        }
        
        // Load filter groups
        if let filterGroups: [SavedFiltersModel] = cacheManager.retrieve(forKey: .filterGroupsCase) {
            allSavedFilters = filterGroups
            print("✅ Successfully loaded filter groups from cache")
            print("Number of filter groups: \(filterGroups.count)")
        } else {
            print("ℹ️ No filter groups found in cache")
        }
        
        // Load saved drills
        if let drills: [GroupModel] = cacheManager.retrieve(forKey: .savedDrillsCase) {
            savedDrills = drills
            print("✅ Successfully loaded saved drills from cache")
        } else {
            print("ℹ️ No saved drills found in cache")
        }
        
        // Load backend IDs for groups
        if let ids: [UUID: Int] = cacheManager.retrieve(forKey: .groupBackendIdsCase) {
            groupBackendIds = ids
            print("✅ Successfully loaded group backend IDs from cache")
        }
        
        // Load liked drills
        if let liked: GroupModel = cacheManager.retrieve(forKey: .likedDrillsCase) {
            likedDrillsGroup = liked
            print("✅ Successfully loaded liked drills from cache")
        } else {
            print("ℹ️ No liked drills found in cache")
        }
        
        // Load backend ID for liked group
        if let id: Int = cacheManager.retrieve(forKey: .likedGroupBackendIdCase) {
            likedGroupBackendId = id
            print("✅ Successfully loaded liked group backend ID from cache")
        }
        
        // After loading from cache, try to refresh from backend
        Task {
            await loadDrillGroupsFromBackend()
        }
    }
    
    private func cacheFilterGroups(name: String) {
        // No need to create new preferences or append again since it's already done in saveFiltersInGroup
        cacheManager.cache(allSavedFilters, forKey: .filterGroupsCase)
        print("💾 Saved \(allSavedFilters.count) filter groups to cache")
    }
    
    func cacheOrderedDrills() {
        print("\n💾 Saving ordered drills to cache...")
        print("Number of drills to save: \(orderedSessionDrills.count)")
        cacheManager.cache(orderedSessionDrills, forKey: .orderedDrillsCase)
    }
    
    // Updated method for caching saved drills
    private func cacheSavedDrills() {
        cacheManager.cache(savedDrills, forKey: .savedDrillsCase)
        // Also cache the backend IDs
        cacheManager.cache(groupBackendIds, forKey: .groupBackendIdsCase)
    }
    
    // Updated method for caching liked drills
    private func cacheLikedDrills() {
        cacheManager.cache(likedDrillsGroup, forKey: .likedDrillsCase)
        // Also cache the backend ID
        if let likedGroupBackendId = likedGroupBackendId {
            cacheManager.cache(likedGroupBackendId, forKey: .likedGroupBackendIdCase)
        }
    }
    
    
    // MARK: User sync functions
    
    // Add new function to sync preferences
    private func syncPreferences() {
        Task {
            do {
                try await DataSyncService.shared.syncUserPreferences(
                    selectedTime: selectedTime,
                    selectedEquipment: selectedEquipment,
                    selectedTrainingStyle: selectedTrainingStyle,
                    selectedLocation: selectedLocation,
                    selectedDifficulty: selectedDifficulty,
                    currentStreak: appModel.currentStreak, // You'll need to track these values
                    highestStreak: appModel.highestStreak,
                    completedSessionsCount: appModel.countOfFullyCompletedSessions
                )
            } catch {
                print("❌ Error syncing preferences: \(error)")
            }
        }
    }
    
    // Add function to sync completed session
    func syncCompletedSession() {
        Task {
            do {
                let completedDrills = orderedSessionDrills.filter { $0.isCompleted }.count
                try await DataSyncService.shared.syncCompletedSession(
                    date: Date(),
                    drills: orderedSessionDrills,
                    totalCompleted: completedDrills,
                    total: orderedSessionDrills.count
                )
            } catch {
                print("❌ Error syncing completed session: \(error)")
            }
        }
    }
    
    // Update preferences when they actually change
    private func debouncedSyncPreferences() {
        let now = Date()
        if now.timeIntervalSince(lastSyncTime) >= syncDebounceInterval {
            lastSyncTime = now
            syncPreferences()
        }
    }
    
    // MARK: - Loading and Syncing with Backend
    
    // Add a method to load all drill groups from the backend
    func loadDrillGroupsFromBackend() async {
        do {
            // Get all groups from backend
            let backendGroups = try await DrillGroupService.shared.getAllDrillGroups()
            
            // Convert backend groups to local model
            var newSavedDrills: [GroupModel] = []
            var newGroupBackendIds: [UUID: Int] = [:]
            
            for backendGroup in backendGroups {
                // Skip liked group, we'll handle it separately
                if backendGroup.isLikedGroup {
                    continue
                }
                
                // Convert API drills to local model
                let drills = backendGroup.drills.map { apiDrill -> DrillModel in
                    return apiDrill.toDrillModel()
                }
                
                // Create local group
                let groupId = UUID()
                let group = GroupModel(
                    id: groupId,
                    name: backendGroup.name,
                    description: backendGroup.description,
                    drills: drills
                )
                
                newSavedDrills.append(group)
                newGroupBackendIds[groupId] = backendGroup.id
            }
            
            // Update local state
            DispatchQueue.main.async {
                self.savedDrills = newSavedDrills
                self.groupBackendIds = newGroupBackendIds
            }
            
            // Get liked drills group
            let likedGroup = try await DrillGroupService.shared.getLikedDrillsGroup()
            let likedDrills = likedGroup.drills.map { apiDrill -> DrillModel in
                return apiDrill.toDrillModel()
            }
            
            // Update liked drills
            DispatchQueue.main.async {
                self.likedDrillsGroup = GroupModel(
                    name: likedGroup.name,
                    description: likedGroup.description,
                    drills: likedDrills
                )
                self.likedGroupBackendId = likedGroup.id
            }
            
            print("✅ Successfully loaded all drill groups from backend")
        } catch {
            print("❌ Error loading drill groups from backend: \(error)")
            print("Using cached groups instead")
        }
    }
}


