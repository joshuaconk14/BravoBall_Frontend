//
//  SecondQuestionnaireView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 10/8/24.
//

import SwiftUI
import RiveRuntime

struct SecondQuestionnaireView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var navigator: NavigationCoordinator
    @StateObject private var questionnaireCoordinator = QuestionnaireCoordinator()
    
    // State for loading view
    @State private var showLoadingView = false
    
    // Questionnaire data
    @State private var selectedYesNoTeam: String = "yesNo"
    @State private var chosenYesNoTeam: [String] = []
    @State private var selectedGoal: String = "goal"
    @State private var chosenGoal: [String] = []
    @State private var selectedTimeline: String = "timeline"
    @State private var chosenTimeline: [String] = []
    @State private var selectedLevel: String = "level"
    @State private var chosenLevel: [String] = []
    @State private var selectedDays: String = "days"
    @State private var chosenDays: [String] = []
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                LazyVStack {
                    Group {
                        switch questionnaireCoordinator.currentStep {
                        case .teamStatus:
                            YesNoTeam(
                                selectedYesNoTeam: $selectedYesNoTeam,
                                chosenYesNoTeam: $chosenYesNoTeam
                            )
                        case .goalSelection:
                            PickGoal(
                                selectedGoal: $selectedGoal,
                                chosenGoal: $chosenGoal
                            )
                        case .timelineSelection:
                            TimelineGoal(
                                selectedTimeline: $selectedTimeline,
                                chosenTimeline: $chosenTimeline
                            )
                        case .trainingLevel:
                            TrainingLevel(
                                selectedLevel: $selectedLevel,
                                chosenLevel: $chosenLevel
                            )
                        case .trainingDays:
                            TrainingDays(
                                selectedDays: $selectedDays,
                                chosenDays: $chosenDays
                            )
                        default:
                            EmptyView()
                        }
                    }
                    .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
                    .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
                }
                .frame(height: 410)
                .padding(.top, 200)
                
                // Bravo Animation and Messages (same as FirstQuestionnaireView)
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 5)
                    .offset(x: questionnaireCoordinator.riveViewOffset.width, 
                           y: questionnaireCoordinator.riveViewOffset.height)
                    .animation(.easeInOut(duration: 0.5), 
                             value: questionnaireCoordinator.riveViewOffset)
                
                Text(questionnaireCoordinator.currentStep.bravoMessage)
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .padding(.horizontal, 80)
                    .multilineTextAlignment(.center)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Navigation Buttons
                QuestionnaireNavigationButtons(
                    isLastStep: questionnaireCoordinator.currentStep == .trainingDays,
                    handleBack: handleBackButton,
                    handleNext: handleNextButton
                )
            }
        }
        .environmentObject(questionnaireCoordinator)
    }
    
    private func handleBackButton() {
        if questionnaireCoordinator.currentStep == .teamStatus {
            navigator.goBack()
        } else {
            questionnaireCoordinator.moveToPrevious()
        }
    }
    
    private func handleNextButton() {
        switch questionnaireCoordinator.currentStep {
        case .teamStatus:
            if !chosenYesNoTeam.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .goalSelection:
            if !chosenGoal.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .timelineSelection:
            if !chosenTimeline.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .trainingLevel:
            if !chosenLevel.isEmpty {
                questionnaireCoordinator.moveToNext()
            }
        case .trainingDays:
            if !chosenDays.isEmpty {
                stateManager.updateSecondQuestionnaire(
                    hasTeam: !chosenYesNoTeam.isEmpty,
                    goal: chosenGoal.first ?? "",
                    timeline: chosenTimeline.first ?? "",
                    skillLevel: chosenLevel.first ?? "",
                    trainingDays: chosenDays
                )
                showLoadingView = true
            }
        default:
            break
        }
    }
}


// MARK: - Preview
struct SecondQuestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        let navigator = NavigationCoordinator()
        
        SecondQuestionnaireView()
            .environmentObject(stateManager)
            .environmentObject(coordinator)
            .environmentObject(navigator)
    }
}
