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
    @Binding var isLoggedIn: Bool

    // binding this struct to questionnairetwo
    @Binding var showQuestionnaireTwo: Bool
    // questionnaires state variables
    @State private var currentQuestionnaireTwo: Int = 0
    @State private var showQuestionnaire = false // need ?
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    @State private var textOpacity4: Double = 0.0
    @State private var textOpacity5: Double = 0.0
    // State variables for animations:
    // animation offset
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    //from questionnaire 1
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

    // after onboarding data is submitted
    @State private var showLoadingView = false

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)  // Base white background
            
            ScrollView {
                LazyVStack {
                    // Add padding at the top to prevent border clipping
                    Spacer()
                        .frame(height: 10)
                    // Current questionnaire REPRESENTATION based on the state variable
                    if currentQuestionnaireTwo == 1 {
                        YesNoTeam(currentQuestionnaireTwo: $currentQuestionnaireTwo,
                                selectedYesNoTeam: $selectedYesNoTeam,
                                chosenYesNoTeam: $chosenYesNoTeam)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaireTwo == 1 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                    } else if currentQuestionnaireTwo == 2 {
                        PickGoal(currentQuestionnaireTwo: $currentQuestionnaireTwo,
                               selectedGoal: $selectedGoal,
                               chosenGoal: $chosenGoal)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaireTwo == 2 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                    } else if currentQuestionnaireTwo == 3 {
                        TimelineGoal(currentQuestionnaireTwo: $currentQuestionnaireTwo,
                                   selectedTimeline: $selectedTimeline,
                                   chosenTimeline: $chosenTimeline)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaireTwo == 3 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                    } else if currentQuestionnaireTwo == 4 {
                        TrainingLevel(currentQuestionnaireTwo: $currentQuestionnaireTwo,
                                    selectedLevel: $selectedLevel,
                                    chosenLevel: $chosenLevel)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaireTwo == 4 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                    } else if currentQuestionnaireTwo == 5 {
                        TrainingDays(currentQuestionnaireTwo: $currentQuestionnaireTwo,
                                   selectedDays: $selectedDays,
                                   chosenDays: $chosenDays)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaireTwo == 5 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                    }
                }
            }
            .frame(height: 410)
            .padding(.top, 200)
            
            Spacer()
            
            // Bravo Animation
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 250, height: 250)
                .padding(.bottom, 5)
                .offset(x: riveViewOffset.width, y: riveViewOffset.height)
                .animation(.easeInOut(duration: 0.5), value: riveViewOffset)
            
            // Bravo Messages
            Group {
                if currentQuestionnaireTwo == 0 {
                    Text("This is going so well! Now I just need to specialize the plan to your needs.")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding(.horizontal, 80)
                        .padding(.bottom, 400)
                        .opacity(textOpacity0)
                        .font(.custom("Poppins-Bold", size: 16))
                } else if currentQuestionnaireTwo == 1 {
                    Text("Are you currently playing for a team?")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .opacity(textOpacity1)
                        .font(.custom("Poppins-Bold", size: 16))
                } else if currentQuestionnaireTwo == 2 {
                    Text("What is your primary goal?")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .opacity(textOpacity2)
                        .font(.custom("Poppins-Bold", size: 16))
                } else if currentQuestionnaireTwo == 3 {
                    Text("When are you looking to achieve this by?")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .opacity(textOpacity3)
                        .font(.custom("Poppins-Bold", size: 16))
                } else if currentQuestionnaireTwo == 4 {
                    Text("Pick your training level.")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .opacity(textOpacity4)
                        .font(.custom("Poppins-Bold", size: 16))
                } else if currentQuestionnaireTwo == 5 {
                    Text("What days would you like to train?")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .opacity(textOpacity5)
                        .font(.custom("Poppins-Bold", size: 16))
                }
            }
            
            // Back Button
            HStack {
                Button(action: {
                    withAnimation {
                        showQuestionnaireTwo = false
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                }
                .padding(.bottom, 725)
                
                Spacer()
            }
            
            // Next Button
            Button(action: handleNextButton) {
                Text("Next")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.top, 700)
        }
        .padding()
        .background(.white)
        .edgesIgnoringSafeArea(.all)
        .fullScreenCover(isPresented: $showLoadingView) {
            PostOnboardingLoadingView(onboardingData: stateManager.onboardingData, isLoggedIn: $isLoggedIn)
        }
    }
    
    private func handleNextButton() {
        if currentQuestionnaireTwo == 0 {
            withAnimation(.spring()) {
                // Move the Rive animation up and show list
                riveViewOffset = CGSize(width: -75, height: -250)
                currentQuestionnaireTwo = 1
                textOpacity0 = 0.0
                textOpacity1 = 1.0
            }
        } else if currentQuestionnaireTwo == 1 && !chosenYesNoTeam.isEmpty {
            withAnimation {
                currentQuestionnaireTwo = 2
                textOpacity1 = 0.0
                textOpacity2 = 1.0
            }
        } else if currentQuestionnaireTwo == 2 && !chosenGoal.isEmpty {
            withAnimation {
                currentQuestionnaireTwo = 3
                textOpacity2 = 0.0
                textOpacity3 = 1.0
            }
        } else if currentQuestionnaireTwo == 3 && !chosenTimeline.isEmpty {
            withAnimation {
                currentQuestionnaireTwo = 4
                textOpacity3 = 0.0
                textOpacity4 = 1.0
            }
        } else if currentQuestionnaireTwo == 4 && !chosenLevel.isEmpty {
            withAnimation {
                currentQuestionnaireTwo = 5
                textOpacity4 = 0.0
                textOpacity5 = 1.0
            }
        } else if currentQuestionnaireTwo == 5 && !chosenDays.isEmpty {
            stateManager.updateSecondQuestionnaire(
                hasTeam: !chosenYesNoTeam.isEmpty,
                goal: chosenGoal.first ?? "",
                timeline: chosenTimeline.first ?? "",
                skillLevel: chosenLevel.first ?? "",
                trainingDays: chosenDays
            )
            submitOnboardingData()
            // TODO: Handle navigation after successful submission
        }
    }

    private func submitOnboardingData() {
        showLoadingView = true
    }
}


// MARK: - Preview
struct SecondQuestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        SecondQuestionnaireView(isLoggedIn: .constant(false), showQuestionnaireTwo: .constant(true))
            .environmentObject(stateManager)
    }
}
