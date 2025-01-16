//
//  MainAppModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/9/25.
//
// Contains other functions and variables within the main app

import Foundation

class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()
    
    // Tab selected in main tab view
    var mainTabSelected = 0

    
    // MARK: Calendar
    
    let calendar = Calendar.current
    
    
    @Published var showDrillResults = false
    @Published var allCompletedSessions: [CompletedSession] = []
    @Published var selectedSession: CompletedSession?
    @Published var streakIncrease: Int = 0
    
    
    struct CompletedSession: Codable {
        let date: Date
        let drills: [DrillData]
        var isCompleted: Bool = true
    }
    
    struct DrillData: Codable {
        let name: String
        let skill: String
        let duration: Int
        let sets: Int
        let reps: Int
        let equipment: [String]
    }
    
    
    // Adding completed session into allCompletedSessions array
    func addCompleteSession(date: Date, drills: [DrillData]) {
        let newSession = CompletedSession(
            date: date,
            drills: drills
        )
        allCompletedSessions.append(newSession)
        
        // Function that will save to UserDefaults
        saveCompletedSessions()
        
        // Debugging
        print ("Session complete")
        print ("date: \(date)")
        for drill in drills {
            print ("name: \(drill.name)")
            print ("skill: \(drill.skill)")
            print ("duration: \(drill.duration)")
            print ("sets: \(drill.sets)")
            print ("reps: \(drill.reps)")
            print ("equipment: \(drill.equipment)")
        }
    }
    
    
    // Bool that checks if day is completed through date comparison
    func isDayCompleted(_ date: Date) -> Bool {
        let targetComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let targetDay = targetComponents.day
        let targetMonth = targetComponents.month
        let targetYear = targetComponents.year
        
        return allCompletedSessions.contains { session in
            let sessionComponents = calendar.dateComponents([.day, .month, .year], from: session.date)
            let sessionDay = sessionComponents.day
            let sessionMonth = sessionComponents.month
            let sessionYear = sessionComponents.year
            
            return sessionDay == targetDay &&
                   sessionMonth == targetMonth &&
                   sessionYear == targetYear
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
