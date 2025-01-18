//
//  MainAppModel.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/9/25.
//
// Contains other functions and variables within the main app

import Foundation

class MainAppModel: ObservableObject {
    let globalSettings = GlobalSettings()
    
    // MARK: Main

    @Published var mainTabSelected = 0
    @Published var inSimulationMode: Bool = true

    
    // MARK: Calendar

    let calendar = Calendar.current

    @Published var allCompletedSessions: [CompletedSession] = []
    @Published var selectedSession: CompletedSession? // For selecting into Drill Card View
    @Published var showCalendar = false
    @Published var showDrillResults = false
    @Published var currentStreak: Int = 0
    @Published var highestStreak: Int = 0
    
    struct CompletedSession: Codable {
        let date: Date  
        let drills: [DrillData]
        let totalCompletedDrills: Int
        let totalDrills: Int
    }

    struct DrillData: Codable { 
        let name: String
        let skill: String
        let duration: Int
        let sets: Int
        let reps: Int
        let equipment: [String]
        let isCompleted: Bool
    }


    
    // Adding completed session into allCompletedSessions array
    func addCompletedSession(date: Date, drills: [DrillData], totalCompletedDrills: Int, totalDrills: Int) {
        let newSession = CompletedSession(
            date: date,
            drills: drills,
            totalCompletedDrills: totalCompletedDrills,
            totalDrills: totalDrills
        )
        allCompletedSessions.append(newSession)

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
            print ("name: \(drill.name)")
            print ("skill: \(drill.skill)")
            print ("duration: \(drill.duration)")
            print ("sets: \(drill.sets)")
            print ("reps: \(drill.reps)")
            print ("equipment: \(drill.equipment)")
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
