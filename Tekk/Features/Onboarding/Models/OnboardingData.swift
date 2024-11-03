//
//  OnboardingData.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation

// structure for onboarding data
struct OnboardingData: Codable {
    // From WelcomeQuestions
    var firstName: String
    var lastName: String
    var ageRange: String
    var level: String
    var position: String
    
    // From FirstQuestionnaire
    var playstyleRepresentatives: [String]  // Which players represent your playstyle
    var strengths: [String]                 // What are your biggest strengths
    var weaknesses: [String]                // What would you like to work on
    
    // From SecondQuestionnaire
    var hasTeam: Bool                       // Are you currently playing for a team
    var primaryGoal: String                 // What is your primary goal
    var timeline: String                    // When looking to achieve this by
    var skillLevel: String                  // Current skill level
    var trainingDays: [String]             // Available training days
}
