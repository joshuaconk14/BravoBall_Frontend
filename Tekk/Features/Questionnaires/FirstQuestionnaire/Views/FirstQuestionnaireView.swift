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
    
    @Binding var isLoggedIn: Bool
    @Binding var showQuestionnaire: Bool
    
    // State variables
    @State private var currentQuestionnaire: Int = 0
    @State private var showQuestionnaireTwo = false
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    // State variables for animations:
    // animation offset
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    
    // Questionnaire data
    @State private var selectedPlayer: String = "player"
    @State private var chosenPlayers: [String] = []
    @State private var selectedStrength: String = "strength"
    @State private var chosenStrengths: [String] = []
    @State private var selectedWeakness: String = "strength"
    @State private var chosenWeaknesses: [String] = []
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            if showQuestionnaireTwo {
                SecondQuestionnaireView(isLoggedIn: $isLoggedIn, showQuestionnaireTwo: $showQuestionnaireTwo)
                    .environmentObject(stateManager)
                    .transition(.move(edge: .trailing))
            } else {
                ScrollView {
                    LazyVStack {
                        Spacer()
                            .frame(height: 10)
                        
                        if currentQuestionnaire == 1 {
                            PlayerRepresentPlaystyle(
                                currentQuestionnaire: $currentQuestionnaire,
                                selectedPlayer: $selectedPlayer,
                                chosenPlayers: $chosenPlayers
                            )
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaire == 1 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                        } else if currentQuestionnaire == 2 {
                            PickStrengths(
                                currentQuestionnaire: $currentQuestionnaire,
                                selectedStrength: $selectedStrength,
                                chosenStrengths: $chosenStrengths
                            )
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaire == 2 ? 0 : UIScreen.main.bounds.width)
                            .environmentObject(stateManager)
                        } else if currentQuestionnaire == 3 {
                            PickWeaknesses(
                                currentQuestionnaire: $currentQuestionnaire,
                                selectedWeakness: $selectedWeakness,
                                chosenWeaknesses: $chosenWeaknesses
                            )
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentQuestionnaire == 3 ? 0 : UIScreen.main.bounds.width)
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
                    if currentQuestionnaire == 0 {
                        Text("Nice! I know so much more about you now! Just a few questions to know your style of play.")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding(.horizontal, 80)
                            .padding(.bottom, 400)
                            .opacity(textOpacity0)
                            .font(.custom("Poppins-Bold", size: 16))
                    } else if currentQuestionnaire == 1 {
                        Text("Which players do you feel represent your playstyle the best?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .opacity(textOpacity1)
                            .font(.custom("Poppins-Bold", size: 16))
                    } else if currentQuestionnaire == 2 {
                        Text("What are your biggest strengths?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .opacity(textOpacity2)
                            .font(.custom("Poppins-Bold", size: 16))
                    } else if currentQuestionnaire == 3 {
                        Text("What would you like to work on?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .opacity(textOpacity3)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                }
                
                // Back Button
                HStack {
                    Button(action: {
                        withAnimation {
                            showQuestionnaire = false
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
        }
        .padding()
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func handleNextButton() {
        if currentQuestionnaire == 0 {
            withAnimation(.spring()) {
                riveViewOffset = CGSize(width: -75, height: -250)
                currentQuestionnaire = 1
                textOpacity0 = 0.0
                textOpacity1 = 1.0
            }
        } else if currentQuestionnaire == 1 && validateQ1() {
            withAnimation {
                currentQuestionnaire = 2
                textOpacity1 = 0.0
                textOpacity2 = 1.0
            }
        } else if currentQuestionnaire == 2 && validateQ2() {
            withAnimation {
                currentQuestionnaire = 3
                textOpacity2 = 0.0
                textOpacity3 = 1.0
            }
        } else if currentQuestionnaire == 3 && validateQ3() {
            withAnimation {
                showQuestionnaireTwo = true
                textOpacity3 = 0.0
            }
        }
    }
    
    private func validateQ1() -> Bool {
        return !chosenPlayers.isEmpty
    }
    
    private func validateQ2() -> Bool {
        return !chosenStrengths.isEmpty
    }
    
    private func validateQ3() -> Bool {
        if !chosenWeaknesses.isEmpty {
            stateManager.updateFirstQuestionnaire(
                playstyle: chosenPlayers,
                strengths: chosenStrengths,
                weaknesses: chosenWeaknesses
            )
            return true
        }
        return false
    }
}

// MARK: - Preview
struct Questionnaire_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        FirstQuestionnaireView(
            isLoggedIn: .constant(false),
            showQuestionnaire: .constant(true)
        )
            .environmentObject(stateManager)
    }
}
