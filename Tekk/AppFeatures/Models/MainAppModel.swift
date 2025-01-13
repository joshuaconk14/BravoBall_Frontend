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
}
