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
        didSet { cacheCompletedSessions() }
    }
    @Published var selectedSession: CompletedSession? // For selecting into Drill Card View
    @Published var showCalendar = false
    @Published var showDrillResults = false
    
    @Published var currentStreak: Int = 0 {
        didSet { cacheCurrentStreak() }
    }
    @Published var highestStreak: Int = 0 {
        didSet { cacheHighestStreak() }
    }
    @Published var countOfFullyCompletedSessions: Int = 0 {
        didSet { cacheCompletedSessionsCount() }
    }
    
    struct CompletedSession: Codable {
        let date: Date
        let drills: [EditableDrillModel]
        let totalCompletedDrills: Int
        let totalDrills: Int
    }
    
    // MARK: - Cache Save Operations
    private func cacheCompletedSessions() {
        cacheManager.cache(allCompletedSessions, forKey: .allCompletedSessionsCase)
        print("💾 Saved \(allCompletedSessions.count) completed sessions to cache")
    }
    
    private func cacheCurrentStreak() {
        cacheManager.cache(currentStreak, forKey: .currentStreakCase)
        print("💾 Saved current streak: \(currentStreak)")
    }
    
    private func cacheHighestStreak() {
        cacheManager.cache(highestStreak, forKey: .highestSreakCase)
        print("💾 Saved highest streak: \(highestStreak)")
    }
    
    private func cacheCompletedSessionsCount() {
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
        
        // Load current streak
        if let retrievedStreak: Int = cacheManager.retrieve(forKey: .currentStreakCase) {
            currentStreak = retrievedStreak
            print("✅ Loaded current streak: \(currentStreak)")
        }
        
        // Load highest streak
        if let retrievedHighest: Int = cacheManager.retrieve(forKey: .highestSreakCase) {
            highestStreak = retrievedHighest
            print("✅ Loaded highest streak: \(highestStreak)")
        }
        
        // Load completed sessions count
        if let retrievedCount: Int = cacheManager.retrieve(forKey: .countOfCompletedSessionsCase) {
            countOfFullyCompletedSessions = retrievedCount
            print("✅ Loaded completed sessions count: \(countOfFullyCompletedSessions)")
        }
        
        print("----------------------------------------")
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
