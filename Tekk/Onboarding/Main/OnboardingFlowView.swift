//
//  OnboardingFlowView.swift
//  BravoBall
//
//  Created by Jordan on 11/6/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct OnboardingFlowView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
    @EnvironmentObject var bravoCoordinator: BravoCoordinator
    
    // All questionnaire states
    @State private var selectedPlayer = ""
    @State private var chosenPlayers: [String] = []
    @State private var selectedStrength = ""
    @State private var chosenStrengths: [String] = []
    @State private var selectedWeakness = ""
    @State private var chosenWeaknesses: [String] = []
    @State private var selectedTeamStatus = ""
    @State private var chosenTeamStatus: [String] = []
    @State private var selectedGoal = ""
    @State private var chosenGoals: [String] = []
    @State private var selectedTimeline = ""
    @State private var chosenTimeline: [String] = []
    @State private var selectedLevel = ""
    @State private var chosenLevel: [String] = []
    @State private var selectedDays = ""
    @State private var chosenDays: [String] = []
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Question content
                Group {
                    switch onboardingCoordinator.currentStep {
                    case .playerStyle:
                        PickPlayers(
                            selectedPlayer: $selectedPlayer,
                            chosenPlayers: $chosenPlayers
                        )
                    case .strengths:
                        PickStrengths(
                            selectedStrength: $selectedStrength,
                            chosenStrengths: $chosenStrengths
                        )
                    // Add other cases for each step
                    default:
                        EmptyView()
                    }
                }
                .transition(.move(edge: onboardingCoordinator.direction == .forward ? .trailing : .leading))
                
                // Bravo
                BravoView()
                    .offset(onboardingCoordinator.riveViewOffset)
                
                // Navigation
                QuestionnaireNavigationButtons(
                    isLastStep: onboardingCoordinator.currentStep == .trainingDays,
                    handleBack: handleBack,
                    handleNext: handleNext
                )
            }
        }
    }
    
    private func handleBack() {
        onboardingCoordinator.moveToPrevious()
    }
    
    private func handleNext() {
        // Validate current step and update state manager
        validateAndProgress()
    }
    
    private func validateAndProgress() {
        switch onboardingCoordinator.currentStep {
        case .playerStyle:
            if !chosenPlayers.isEmpty {
                onboardingCoordinator.moveToNext()
            }
        // Add other cases
        case .trainingDays:
            if !chosenDays.isEmpty {
                // Final update
                stateManager.updateSecondQuestionnaire(
                    hasTeam: !chosenTeamStatus.isEmpty,
                    goal: chosenGoals.first ?? "",
                    timeline: chosenTimeline.first ?? "",
                    skillLevel: chosenLevel.first ?? "",
                    trainingDays: chosenDays
                )
            }
        default:
            break
        }
    }
}
