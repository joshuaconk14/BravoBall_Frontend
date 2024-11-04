//
//  FirstFirstQuestionnaireView.swift
//  BravoBall
//
//  Created by Josh on 8/26/24.
//
//  This file contains the FirstQuestionnaireView, which is used to show the questionnaire to the user.

import SwiftUI
import RiveRuntime

// MARK: - Main body
struct FirstQuestionnaireView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var navigator: NavigationCoordinator
    @StateObject private var questionnaireCoordinator = QuestionnaireCoordinator()
    
    // Questionnaire data
    @State private var selectedPlayer: String = "player"
    @State private var chosenPlayers: [String] = []
    @State private var selectedStrength: String = "strength"
    @State private var chosenStrengths: [String] = []
    @State private var selectedWeakness: String = "weakness"
    @State private var chosenWeaknesses: [String] = []
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack {
                    Spacer().frame(height: 10)
                    
                    // Questionnaire Views
                    Group {
                        switch questionnaireCoordinator.currentStep {
                        case .playerSelection:
                            PickPlayers(
                                selectedPlayer: $selectedPlayer,
                                chosenPlayers: $chosenPlayers
                            )
                        case .strengthSelection:
                            PickStrengths(
                                selectedStrength: $selectedStrength,
                                chosenStrengths: $chosenStrengths
                            )
                        case .weaknessSelection:
                            PickWeaknesses(
                                selectedWeakness: $selectedWeakness,
                                chosenWeaknesses: $chosenWeaknesses
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
                    .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
                    .environmentObject(stateManager)
                }
                .frame(height: 410)
                .padding(.top, 200)
                
                Spacer()
                
                // Bravo Animation
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 5)
                    .offset(x: questionnaireCoordinator.riveViewOffset.width, 
                           y: questionnaireCoordinator.riveViewOffset.height)
                    .animation(.easeInOut(duration: 0.5), 
                             value: questionnaireCoordinator.riveViewOffset)
                
                // Bravo Messages
                Text(questionnaireCoordinator.currentStep.bravoMessage)
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .padding(.horizontal, 80)
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Navigation Buttons
                QuestionnaireNavigationButtons(
                    isLastStep: questionnaireCoordinator.currentStep == .weaknessSelection,
                    handleBack: handleBackButton,
                    handleNext: handleNextButton
                )
            }
        }
        .padding()
        .background(.white)
        .edgesIgnoringSafeArea(.all)
        .environmentObject(questionnaireCoordinator)
    }
    
    private func handleBackButton() {
        if questionnaireCoordinator.currentStep == .playerSelection {
            navigator.goBack()
        } else {
            questionnaireCoordinator.moveToPrevious()
        }
    }
    
    private func handleNextButton() {
        switch questionnaireCoordinator.currentStep {
        case .playerSelection:
            if !chosenPlayers.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .strengthSelection:
            if !chosenStrengths.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .weaknessSelection:
            if !chosenWeaknesses.isEmpty {
                stateManager.updateFirstQuestionnaire(
                    playstyle: chosenPlayers,
                    strengths: chosenStrengths,
                    weaknesses: chosenWeaknesses
                )
                navigator.navigate(to: .secondQuestionnaire)
            }
        default:
            break
        }
    }
}

// MARK: - Preview
struct Questionnaire_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        let navigator = NavigationCoordinator()
        
        FirstQuestionnaireView()
            .environmentObject(stateManager)
            .environmentObject(coordinator)
            .environmentObject(navigator)
    }
}
