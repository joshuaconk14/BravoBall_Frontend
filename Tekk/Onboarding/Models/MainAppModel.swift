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

class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()

    
    // MARK: Main
    @Published var homeTab = RiveViewModel(fileName: "Tab_House")
    @Published var progressTab = RiveViewModel(fileName: "Tab_Calendar")
    @Published var savedTab = RiveViewModel(fileName: "Tab_Saved")
    @Published var profileTab = RiveViewModel(fileName: "Tab_Dude")
    
    @Published var mainTabSelected = 0
    @Published var inSimulationMode: Bool = true
    
    
    
    
    
    
    
    // MARK: testing
    
    
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
    
    
    
    // Toast message model
    struct ToastMessage: Equatable {
        let type: ToastType
        let message: String
        
        static func success(_ message: String) -> ToastMessage {
            ToastMessage(type: .success, message: message)
        }
        
        static func notAllowed(_ message: String) -> ToastMessage {
            ToastMessage(type: .notAllowed, message: message)
        }
        
        static func unAdded(_ message: String) -> ToastMessage {
            ToastMessage(type: .unAdded, message: message)
        }
        
        enum ToastType {
            case success
            case notAllowed
            case unAdded
            case error // need this for server error message?
            
            var color: Color {
                switch self {
                case .success: return .green
                case .notAllowed: return .red
                case .unAdded: return .green
                case .error: return .blue
                }
            }
            
            var icon: String {
                switch self {
                case .success: return "checkmark.circle.fill"
                case .notAllowed: return "xmark.circle.fill"
                case .unAdded: return "checkmark.circle.fill"
                case .error: return "info.circle.fill"
                }
            }
        }
    }

    
    
    
    
    
    
    
    
    
    // MARK: Session generator
    
    
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
    }
    
        
    
    
    
    // Enus and types for filters
    
    @Published var selectedFilter: FilterType?

    
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
    
    
    // Types (automatically nil)
    @Published var selectedSkill: SkillType?
    @Published var selectedTrainingStyle: TrainingStyleType?
    @Published var selectedDifficulty: DifficultyType?
    
        
    enum SkillType: String, CaseIterable {
        case passing = "Passing"
        case dribbling = "Dribbling"
        case shooting = "Shooting"
        case firstTouch = "First Touch"
        case crossing = "Crossing"
        case defending = "Defending"
        case goalkeeping = "Goalkeeping"
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
    
    
    
    
    // MARK: Drill Detail View
    

    
    
    // MARK: Calendar
    
    let calendar = Calendar.current
    
    @Published var allCompletedSessions: [CompletedSession] = []
    @Published var selectedSession: CompletedSession? // For selecting into Drill Card View
    @Published var showCalendar = false
    @Published var showDrillResults = false
    @Published var currentStreak: Int = 0
    @Published var highestStreak: Int = 0
    @Published var countOfFullyCompletedSessions: Int = 0
    
    struct CompletedSession: Codable {
        let date: Date
        let drills: [EditableDrillModel]
        let totalCompletedDrills: Int
        let totalDrills: Int
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
        
        // Function that will save to UserDefaults
        func saveCompletedSessions() {
            if let encoded = try? JSONEncoder().encode(allCompletedSessions) {
                UserDefaults.standard.set(encoded, forKey: "completedSessions")
            }
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
    
    
    // Save to UserDefaults
    func saveCompletedSessions() {
        if let encoded = try? JSONEncoder().encode(allCompletedSessions) {
            UserDefaults.standard.set(encoded, forKey: "completedSessions")
        }
    }
    
    // Decode from UserDefaults
    func loadCompletedSessions() {
        if let data = UserDefaults.standard.data(forKey: "completedSessions"),
           let decoded = try? JSONDecoder().decode([CompletedSession].self, from: data) {
            allCompletedSessions = decoded
        }
    }
    
    // Sets the highest streak
    func highestStreakSetter(streak: Int) {
        if streak > highestStreak {
            highestStreak = streak
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
    
}
