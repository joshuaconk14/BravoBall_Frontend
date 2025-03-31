///
//  MainAppModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/9/25.
//
// Contains other functions and variables within the main app

import Foundation
import UIKit
import RiveRuntime
import SwiftUI
import SwiftKeychainWrapper

class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()
    
    
    
    private let cacheManager = CacheManager.shared

    
    @Published var homeTab = RiveViewModel(fileName: "Tab_House")
    @Published var progressTab = RiveViewModel(fileName: "Tab_Calendar")
    @Published var savedTab = RiveViewModel(fileName: "Tab_Saved")
    @Published var profileTab = RiveViewModel(fileName: "Tab_Dude")
    
    @Published var mainTabSelected = 0
    @Published var inSimulationMode: Bool = true
    
    
    // Toast messages
    @Published var toastMessage: ToastMessage? {
           didSet {
               if toastMessage != nil {
                   // Automatically dismiss after delay
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                       withAnimation {
                           self.toastMessage = nil
                       }
                   }
               }
           }
       }

    // View state
    @Published var viewState = ViewState()
    
    struct ViewState: Codable {
        var showingDrills = false
        var showFilter: Bool = true
        var showHomePage: Bool = true
        var showPreSessionTextBubble: Bool = false
        var showPostSessionTextBubble: Bool = false
        var showFieldBehindHomePage: Bool = false
        var showFilterOptions: Bool = false
        var showGroupFilterOptions: Bool = false
        var showSavedFilters: Bool = false
        var showSaveFiltersPrompt: Bool = false
        var showSearchDrills: Bool = false
        var showDeleteButtons: Bool = false
        var showingDrillDetail: Bool = false
        var showSkillSearch: Bool = false
        var showSessionComplete: Bool = false
        var showBravo: Bool = true
        
        // Reset view states when user logs out / resets app
        mutating func reset() {
                showingDrills = false
                showFilter = true
                showHomePage = true
                showPreSessionTextBubble = false
                showPostSessionTextBubble = false
                showFieldBehindHomePage = false
                showFilterOptions = false
                showGroupFilterOptions = false
                showSavedFilters = false
                showSaveFiltersPrompt = false
                showSearchDrills = false
                showDeleteButtons = false
                showingDrillDetail = false
                showSkillSearch = false
                showSessionComplete = false
                showBravo = true
            }
    }
    
    // Enus and types for filters
    
    @Published var selectedFilter: FilterType?
    
    // Function to map FilterType to FilterIcon
    func icon(for type: FilterType) -> FilterIcon {
        switch type {
        case .time:
            return .time
        case .equipment:
            return .equipment
        case .trainingStyle:
            return .trainingStyle
        case .location:
            return .location
        case .difficulty:
            return .difficulty
        }
    }
    
    
    // Types for search drills ByType section (automatically nil)
    @Published var selectedSkillButton: SkillType?
    @Published var selectedTrainingStyle: TrainingStyleType?
    @Published var selectedDifficulty: DifficultyType?
    


    
    
    // MARK: Calendar
    
    let calendar = Calendar.current
    
    @Published var allCompletedSessions: [CompletedSession] = [] {
        didSet {
            cacheCompletedSessions()
            
            // Only sync the most recently added session if the array grew
            if allCompletedSessions.count > oldValue.count,
               let latestSession = allCompletedSessions.last {
                Task {
                    do {
                        // Sync the completed session
                        try await DataSyncService.shared.syncCompletedSession(
                            date: latestSession.date,
                            drills: latestSession.drills,
                            totalCompleted: latestSession.totalCompletedDrills,
                            total: latestSession.totalDrills
                        )
                        print("✅ Successfully synced latest completed session")
                        
                        // Then sync the progress history
                        try await DataSyncService.shared.syncProgressHistory(
                            currentStreak: currentStreak,
                            highestStreak: highestStreak,
                            completedSessionsCount: countOfFullyCompletedSessions
                        )
                        print("✅ Successfully synced progress history")
                    } catch {
                        print("❌ Error syncing session data: \(error)")
                    }
                }
            }
        }
    }
    @Published var selectedSession: CompletedSession? // For selecting into Drill Card View
    @Published var showCalendar = false
    @Published var showDrillResults = false
    
    @Published var currentStreak: Int = 0 {
        didSet {
            if currentStreak != oldValue {
                cacheCurrentStreak()
                syncProgressHistory()
            }
        }
    }
    @Published var highestStreak: Int = 0 {
        didSet {
            if highestStreak != oldValue {
                cacheHighestStreak()
                syncProgressHistory()
            }
        }
    }
    @Published var countOfFullyCompletedSessions: Int = 0 {
        didSet {
            if countOfFullyCompletedSessions != oldValue {
                cacheCompletedSessionsCount()
                syncProgressHistory()
            }
        }
    }
    
    private func syncProgressHistory() {
        Task {
            do {
                // First verify the current values match what we expect
                let cachedCurrentStreak: Int = cacheManager.retrieve(forKey: .currentStreakCase) ?? 0
                let cachedHighestStreak: Int = cacheManager.retrieve(forKey: .highestSreakCase) ?? 0
                let cachedCompletedCount: Int = cacheManager.retrieve(forKey: .countOfCompletedSessionsCase) ?? 0
                
                // Only sync if our current values match the cache (ensures we're not working with stale data)
                guard currentStreak == cachedCurrentStreak &&
                      highestStreak == cachedHighestStreak &&
                      countOfFullyCompletedSessions == cachedCompletedCount else {
                    print("⚠️ Local values don't match cache, skipping sync")
                    return
                }
                
                try await DataSyncService.shared.syncProgressHistory(
                    currentStreak: currentStreak,
                    highestStreak: highestStreak,
                    completedSessionsCount: countOfFullyCompletedSessions
                )
                print("✅ Successfully synced progress history with verified values")
            } catch {
                print("❌ Error syncing progress history: \(error)")
            }
        }
    }
    
    // MARK: - Cache Save Operations
    func cacheCompletedSessions() {
        cacheManager.cache(allCompletedSessions, forKey: .allCompletedSessionsCase)
        print("💾 Saved \(allCompletedSessions.count) completed sessions to cache")
    }
    
    func cacheCurrentStreak() {
        cacheManager.cache(currentStreak, forKey: .currentStreakCase)
        print("💾 Saved current streak: \(currentStreak)")
    }
    
    func cacheHighestStreak() {
        cacheManager.cache(highestStreak, forKey: .highestSreakCase)
        print("💾 Saved highest streak: \(highestStreak)")
    }
    
    func cacheCompletedSessionsCount() {
        cacheManager.cache(countOfFullyCompletedSessions, forKey: .countOfCompletedSessionsCase)
        print("💾 Saved completed sessions count: \(countOfFullyCompletedSessions)")
    }
    
    // MARK: - Cache Load Operations
    func loadCachedData() {
        print("\n📱 Loading cached data for current user...")
        let userEmail = KeychainWrapper.standard.string(forKey: "userEmail") ?? "no user"
        print("\n👤 USER SESSION INFO:")
        print("----------------------------------------")
        print("Current user email: \(userEmail)")
        
        // Load completed sessions
        if let retrievedSessions: [CompletedSession] = cacheManager.retrieve(forKey: .allCompletedSessionsCase) {
            allCompletedSessions = retrievedSessions
            print("✅ Loaded \(allCompletedSessions.count) completed sessions")
        }
        
        // Load progress history from cache first
        let cachedCurrentStreak: Int = cacheManager.retrieve(forKey: .currentStreakCase) ?? 0
        let cachedHighestStreak: Int = cacheManager.retrieve(forKey: .highestSreakCase) ?? 0
        let cachedCompletedCount: Int = cacheManager.retrieve(forKey: .countOfCompletedSessionsCase) ?? 0
        
        // Set the values without triggering observers
        self.currentStreak = cachedCurrentStreak
        self.highestStreak = cachedHighestStreak
        self.countOfFullyCompletedSessions = cachedCompletedCount
        
        print("✅ Loaded from cache - Current Streak: \(cachedCurrentStreak), Highest: \(cachedHighestStreak), Completed: \(cachedCompletedCount)")
        print("----------------------------------------")
        
        // Then fetch from backend to ensure we're up to date
        Task {
            do {
                let response = try await DataSyncService.shared.fetchProgressHistory()
                
                // Only update if the backend values are different from cache
                if response.currentStreak != cachedCurrentStreak ||
                   response.highestStreak != cachedHighestStreak ||
                   response.completedSessionsCount != cachedCompletedCount {
                    
                    await MainActor.run {
                        self.currentStreak = response.currentStreak
                        self.highestStreak = response.highestStreak
                        self.countOfFullyCompletedSessions = response.completedSessionsCount
                        print("✅ Updated with backend data - Current: \(response.currentStreak), Highest: \(response.highestStreak), Completed: \(response.completedSessionsCount)")
                    }
                }
            } catch {
                print("⚠️ Could not fetch from backend, using cached values: \(error)")
            }
        }
    }
    
    // Adding completed session into allCompletedSessions array
    func addCompletedSession(date: Date, drills: [EditableDrillModel], totalCompletedDrills: Int, totalDrills: Int) {
        let newSession = CompletedSession(
            date: date,
            drills: drills,
            totalCompletedDrills: totalCompletedDrills,
            totalDrills: totalDrills
        )
        allCompletedSessions.append(newSession)
        
        
        // Increase count of fully complete sessions if 100% done
        if totalCompletedDrills == totalDrills {
            countOfFullyCompletedSessions += 1
        }
        
        // Debugging
        print ("Session data received")
        print ("date: \(date)")
        print ("score: \(totalCompletedDrills) / \(totalDrills)")
        for drill in drills {
            print ("name: \(drill.drill.title)")
            print ("skill: \(drill.drill.skill)")
            print ("duration: \(drill.totalDuration)")
            print ("sets: \(drill.totalSets)")
            print ("reps: \(drill.totalReps)")
            print ("equipment: \(drill.drill.equipment)")
            print ("Session completed: \(drill.isCompleted)")
        }
    }
    
    // return the data in the drill results view in CompletedSession structure
    func getSessionForDate(_ date: Date) -> CompletedSession? {
        let calendar = Calendar.current
        return allCompletedSessions.first { session in
            calendar.isDate(session.date, inSameDayAs: date)
        }
    }
    
    // MARK: App Settings
    
    // Alert types for ProfileVIew logout and delete buttons
    @Published var showAlert = false
    @Published var alertType: AlertType = .none
    
    
    // Case switches for ProfileVIew logout and delete buttons
    enum AlertType {
        case logout
        case delete
        case none
    }
    
    
    // TODO: fix this
    
    // Sets the highest streak
    func highestStreakSetter(streak: Int) {
        if streak > highestStreak {
            highestStreak = streak
        }
    }
    
    
    
    
    
    
    
    // When logging out
    
    func cleanupOnLogout() {
        // Reset view state
        viewState = ViewState()
        
        // Reset tab selection
        mainTabSelected = 0
        
        // Reset selections
        selectedFilter = nil
        selectedSkillButton = nil
        selectedTrainingStyle = nil
        selectedDifficulty = nil
        selectedSession = nil
        showCalendar = false
        showDrillResults = false
        
        // Clear any active toast messages
        toastMessage = nil
        
        
        allCompletedSessions = []
        currentStreak = 0
        highestStreak = 0
        countOfFullyCompletedSessions = 0
    }
    
}

struct CompletedSession: Codable {
    let date: Date
    let drills: [EditableDrillModel]
    let totalCompletedDrills: Int
    let totalDrills: Int
}
