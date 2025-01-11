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
    
    // testing
    @Published var currentProgress = 0  // Track which button should show checkmark
    @Published var addCheckMark = false
    @Published var streakIncrease: Int = 0
    @Published var interactedDayShowGold = false
    @Published var currentWeek = 0
    
    

  

    
    
    
    
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
