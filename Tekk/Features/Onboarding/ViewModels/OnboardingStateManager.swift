//
//  OnboardingStateManager.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation

class OnboardingStateManager: ObservableObject {
    @Published var onboardingData = OnboardingData(
        firstName: "",
        lastName: "",
        ageRange: "",
        level: "",
        position: "",
        playstyleRepresentatives: [],
        strengths: [],
        weaknesses: [],
        hasTeam: false,
        primaryGoal: "",
        timeline: "",
        skillLevel: "",
        trainingDays: []
    )
    
    func updateWelcomeData(firstName: String, lastName: String, ageRange: String, level: String, position: String) {
        onboardingData.firstName = firstName
        onboardingData.lastName = lastName
        onboardingData.ageRange = ageRange
        onboardingData.level = level
        onboardingData.position = position
    }
    
    func updateFirstQuestionnaire(playstyle: [String], strengths: [String], weaknesses: [String]) {
        onboardingData.playstyleRepresentatives = playstyle
        onboardingData.strengths = strengths
        onboardingData.weaknesses = weaknesses
    }
    
    func updateSecondQuestionnaire(hasTeam: Bool, goal: String, timeline: String, skillLevel: String, trainingDays: [String]) {
        onboardingData.hasTeam = hasTeam
        onboardingData.primaryGoal = goal
        onboardingData.timeline = timeline
        onboardingData.skillLevel = skillLevel
        onboardingData.trainingDays = trainingDays
    }
}
