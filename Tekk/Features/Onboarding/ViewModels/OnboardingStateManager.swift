//
//  OnboardingStateManager.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation

class OnboardingStateManager: ObservableObject {
    
    init() {
        print("🟡 OnboardingStateManager initialized")
        print("Initial onboardingData: \(onboardingData)")
    }
    
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
        print("🟢 Welcome Data Updated:")
        print("Name: \(firstName) \(lastName)")
        print("Age: \(ageRange)")
        print("Level: \(level)")
        print("Position: \(position)")
    }
    
    func updateFirstQuestionnaire(playstyle: [String], strengths: [String], weaknesses: [String]) {
        onboardingData.playstyleRepresentatives = playstyle
        onboardingData.strengths = strengths
        onboardingData.weaknesses = weaknesses
        print("🔵 First Questionnaire Data Updated:")
        print("Playstyle: \(playstyle)")
        print("Strengths: \(strengths)")
        print("Weaknesses: \(weaknesses)")
    }
    
    func updateSecondQuestionnaire(hasTeam: Bool, goal: String, timeline: String, skillLevel: String, trainingDays: [String]) {
        onboardingData.hasTeam = hasTeam
        onboardingData.primaryGoal = goal
        onboardingData.timeline = timeline
        onboardingData.skillLevel = skillLevel
        onboardingData.trainingDays = trainingDays
        print("🔴 Second Questionnaire Data Updated:")
        print("Has Team: \(hasTeam)")
        print("Goal: \(goal)")
        print("Timeline: \(timeline)")
        print("Skill Level: \(skillLevel)")
        print("Training Days: \(trainingDays)")
        print("\n📱 Final Onboarding Data:")
        print(onboardingData)
    }
}
