////
////  OnboardingViewModel.swift
////  BravoBall
////
////  Created by Jordan on 1/6/25.
////
//
//import Foundation
//import SwiftUI
//
//class OnboardingViewModel: ObservableObject {
//    @Published var onboardingData = OnboardingData()
//    @Published var navigationPath: [OnboardingStep] = []
//    
//    // MARK: - Navigation
//    func start() {
//        navigationPath.append(.welcome)
//    }
//    
//    func navigateToNext() {
//        if let currentStep = navigationPath.last,
//           let nextStep = currentStep.nextStep {
//            navigationPath.append(nextStep)
//        }
//    }
//    
//    func navigateBack() {
//        navigationPath.removeLast()
//    }
//    
//    // MARK: - Data Updates
//    func updatePersonalInfo(firstName: String, lastName: String) {
//        onboardingData.firstName = firstName
//        onboardingData.lastName = lastName
//        navigateToNext()
//    }
//    
//    func updateAgeAndLevel(ageRange: String, level: String) {
//        onboardingData.ageRange = ageRange
//        onboardingData.level = level
//        navigateToNext()
//    }
//    
//    func updatePosition(_ position: String) {
//        onboardingData.position = position
//        navigateToNext()
//    }
//    
//    func updatePlaystyle(_ players: [String]) {
//        onboardingData.playstyleRepresentatives = players
//        navigateToNext()
//    }
//    
//    func updateSkills(strengths: [String], weaknesses: [String]) {
//        onboardingData.strengths = strengths
//        onboardingData.weaknesses = weaknesses
//        navigateToNext()
//    }
//    
//    func updateGoals(hasTeam: Bool, goal: String, timeline: String, skillLevel: String) {
//        onboardingData.hasTeam = hasTeam
//        onboardingData.primaryGoal = goal
//        onboardingData.timeline = timeline
//        onboardingData.skillLevel = skillLevel
//        navigateToNext()
//    }
//    
//    func updateSchedule(_ days: [String]) {
//        onboardingData.trainingDays = days
//        navigateToNext()
//    }
//    
//    func updateEquipment(_ equipment: [String]) {
//        onboardingData.availableEquipment = equipment
//        navigateToNext()
//    }
//    
//    // MARK: - Submission
//    func submitOnboarding() async throws -> Bool {
//        guard onboardingData.isComplete else {
//            throw OnboardingError.incompleteData
//        }
//        
//        let response = try await OnboardingService.shared.submitOnboardingData(data: onboardingData)
//        
//        // Store access token
//        UserDefaults.standard.set(response.access_token, forKey: "accessToken")
//        
//        // Update drills in ViewModel
//        DrillsViewModel.shared.recommendedDrills = response.recommendations
//        DrillsViewModel.shared.userEquipment = response.metadata.availableEquipment
//        
//        return true
//    }
//}
//
//enum OnboardingError: Error {
//    case incompleteData
//} 
