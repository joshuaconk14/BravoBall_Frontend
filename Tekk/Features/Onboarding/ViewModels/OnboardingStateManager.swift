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
    
    // takes the structure from OnboardingData and creates an instance
    @Published var onboardingData = OnboardingData(
        firstName: "",
        lastName: "",
        email: "",
        password: "",
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
        trainingDays: [],
        availableEquipment: []
    )
    
    func updateWelcomeData(ageRange: String, level: String, position: String) {
        onboardingData.ageRange = ageRange
        onboardingData.level = level
        onboardingData.position = position
        print("🟢 Welcome Data Updated:")
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
    
    func updateSecondQuestionnaire(hasTeam: Bool, goal: String, timeline: String, skillLevel: String, trainingDays: [String], availableEquipment: [String]) {
        onboardingData.hasTeam = hasTeam
        onboardingData.primaryGoal = goal
        onboardingData.timeline = timeline
        onboardingData.skillLevel = skillLevel
        onboardingData.trainingDays = trainingDays
        onboardingData.availableEquipment = availableEquipment
        print("🔴 Second Questionnaire Data Updated:")
        print("Has Team: \(hasTeam)")
        print("Goal: \(goal)")
        print("Timeline: \(timeline)")
        print("Skill Level: \(skillLevel)")
        print("Training Days: \(trainingDays)")
        print("Available Equipment: \(availableEquipment)")
        print("\n📱 Final Onboarding Data:")
        print(onboardingData)
    }
    
    // TODO: create a register function based on what you give the RegisterView
    func updateRegister(firstName: String, lastName: String, email: String, password: String) {
        onboardingData.firstName = firstName
        onboardingData.lastName = lastName
        onboardingData.email = email
        onboardingData.password = password
        print("🟣 Register Updated:")
        print("Name: \(firstName) \(lastName)")
        print("Email: \(email)")
        print("Password: \(password)")
    }
}
