//
//  WelcomeView.swift
//  BravoBall
//
//  Created by Josh on 9/28/24.
//  This file contains the LoginView, which is used to welcome the user.

import SwiftUI
import RiveRuntime

struct WelcomeView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var isLoggedIn: Bool
    @State private var showQuestionnaire = false
    @Binding var showWelcome: Bool
    
    @State private var currentWelcomeStage = 0
    @State private var riveViewOffset: CGSize = .zero
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    
    // State for selections
    @State private var selectedAge = ""
    @State private var chosenAge: [String] = []
    @State private var selectedLevel = ""
    @State private var chosenLevel: [String] = []
    @State private var selectedPosition = ""
    @State private var chosenPosition: [String] = []
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            if showQuestionnaire {
                FirstQuestionnaireView(
                    isLoggedIn: $isLoggedIn,
                    showQuestionnaire: $showQuestionnaire
                )
                .environmentObject(stateManager)
                .transition(.move(edge: .trailing))
            } else {
                ScrollView {
                    LazyVStack {
                        Spacer()
                            .frame(height: 10)
                        
                        if currentWelcomeStage >= 1 {
                            if currentWelcomeStage == 1 {
                                SelectAgeRange(
                                    currentWelcomeStage: $currentWelcomeStage,
                                    selectedAge: $selectedAge,
                                    chosenAge: $chosenAge
                                )
                                .transition(.move(edge: .trailing))
                                .animation(.easeInOut)
                                .offset(x: currentWelcomeStage == 1 ? 0 : UIScreen.main.bounds.width)
                            } else if currentWelcomeStage == 2 {
                                SelectLevel(
                                    currentWelcomeStage: $currentWelcomeStage,
                                    selectedLevel: $selectedLevel,
                                    chosenLevel: $chosenLevel
                                )
                                .transition(.move(edge: .trailing))
                                .animation(.easeInOut)
                                .offset(x: currentWelcomeStage == 2 ? 0 : UIScreen.main.bounds.width)
                            } else if currentWelcomeStage == 3 {
                                SelectPosition(
                                    currentWelcomeStage: $currentWelcomeStage,
                                    selectedPosition: $selectedPosition,
                                    chosenPosition: $chosenPosition
                                )
                                .transition(.move(edge: .trailing))
                                .animation(.easeInOut)
                                .offset(x: currentWelcomeStage == 3 ? 0 : UIScreen.main.bounds.width)
                            }
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
                    if currentWelcomeStage == 0 {
                        Text("Hello there, I'm Bravo! Let's help you become a more tekky player.")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding(.horizontal, 80)
                            .padding(.bottom, 400)
                            .font(.custom("Poppins-Bold", size: 16))
                            .opacity(textOpacity0)
                    } else if currentWelcomeStage == 1 {
                        Text("What's your age range?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .font(.custom("Poppins-Bold", size: 16))
                            .opacity(textOpacity1)
                    } else if currentWelcomeStage == 2 {
                        Text("What's your playing level?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .font(.custom("Poppins-Bold", size: 16))
                            .opacity(textOpacity2)
                    } else if currentWelcomeStage == 3 {
                        Text("What position do you play?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                            .padding(.bottom, 500)
                            .padding(.leading, 150)
                            .font(.custom("Poppins-Bold", size: 16))
                            .opacity(textOpacity3)
                    }
                }
                
                // Back Button
                HStack {
                    Button(action: handleBackButton) {
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
    
    private func handleBackButton() {
        if currentWelcomeStage > 0 {
            withAnimation {
                currentWelcomeStage -= 1
                if currentWelcomeStage == 0 {
                    riveViewOffset = .zero
                }
            }
        } else {
            withAnimation {
                showWelcome = false
            }
        }
    }
    
    private func handleNextButton() {
        if currentWelcomeStage == 0 {
            withAnimation(.spring()) {
                riveViewOffset = CGSize(width: -75, height: -250)
                currentWelcomeStage = 1
                textOpacity0 = 0.0
                textOpacity1 = 1.0
            }
        } else if currentWelcomeStage == 1 && !chosenAge.isEmpty {
            withAnimation {
                currentWelcomeStage = 2
                textOpacity1 = 0.0
                textOpacity2 = 1.0
            }
        } else if currentWelcomeStage == 2 && !chosenLevel.isEmpty {
            withAnimation {
                currentWelcomeStage = 3
                textOpacity2 = 0.0
                textOpacity3 = 1.0
            }
        } else if currentWelcomeStage == 3 && !chosenPosition.isEmpty {
            stateManager.updateWelcomeData(
                firstName: "",
                lastName: "",
                ageRange: chosenAge[0],
                level: chosenLevel[0],
                position: chosenPosition[0]
            )
            withAnimation {
                showQuestionnaire = true
            }
        }
    }
}


// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        WelcomeView(
            isLoggedIn: .constant(false),
            showWelcome: .constant(false)
        )
        .environmentObject(stateManager)
    }
}
