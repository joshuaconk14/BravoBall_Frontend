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
    
    var mainTabSelected = 0
    
    @Published var showDrillShower = false
    
    // for each day
    @Published var currentDay = 0  // Track which button should show checkmark
    @Published var streakIncrease: Int = 0
    @Published var interactedDayShowGreen = false
    
    
    
    // for each week
    @Published var currentWeek = 0
    @Published var completedWeeks: [WeekData] = []
    
    struct WeekData {
        let weekNumberDisplayed: Int
        var completedDays: Int = 0
        var isCompleted: Bool = false
    }
    
    
    func completedSessionIndicator() {
        if currentDay == 6 {
            // create a new week
            let currentWeekCompleted = WeekData(weekNumberDisplayed: completedWeeks.count + 1) // + 1 since not added yet to the array
            completedWeeks.append(currentWeekCompleted)
            completedWeeks[currentWeek].isCompleted = true
            currentWeek += 1
            currentDay = 0 // reset for the new week
        } else {
            currentDay += 1
        }
    }
  

    
    
    
    
    // Alert types for ProfileVIew logout and delete buttons
    @Published var showAlert = false
    @Published var alertType: AlertType = .none

    
    // Case switches for ProfileVIew logout and delete buttons
    enum AlertType {
        case logout
        case delete
        case none
    }
    
    
    
    
    
    
    
    // Calendar structures and functions
    
    let calendar = Calendar.current
    
    struct CompletedSession: Codable {
        let date: Date
        let drills: [DrillData] // TODO: make drill card structure?
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
    
    @Published var allCompletedSessions: [CompletedSession] = []
    
    
    // adding completed session into allCompletedSessions array
    func addCompleteSession(date: Date, drills: [DrillData]) {
        let newSession = CompletedSession(
            date: date,
            drills: drills
        )
        allCompletedSessions.append(newSession)
        
        // Function that will save to UserDefaults
        saveCompletedSessions()
        
        // Accessing the actual data instead of the type
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
        let calendar = Calendar.current
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
}
