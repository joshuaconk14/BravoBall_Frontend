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

    // Note: Binding/ Bool binds this structure, state private func on other pages determines function of this structure
    @State private var textOpacity1: Double = 1.0
    @State private var textOpacity2: Double = 0.0
    // welcomeInput is where bravo is asking for player details, this is what will show when next button on hello bravo page is clicked
    @State private var welcomeInput: Int = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedAge: String = "Select your Age"
    @State private var selectedLevel: String = "Select your Level"
    @State private var selectedPosition: String = "Select your Position"
    // For delayed transitions for questionnaires
    @State private var animationStage = 0
    
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    // var for matchedGeometry function
    @Namespace var questionnaireSpace
    
    
    var body: some View {
        VStack {
            ZStack {
                Color.white.edgesIgnoringSafeArea(.all)  // Base white background
                
                content
                
                // Only show FirstQuestionnaireView when showQuestionnaire is true
                if showQuestionnaire {
                    FirstQuestionnaireView(
                        isLoggedIn: $isLoggedIn,
                        showQuestionnaire: $showQuestionnaire
                    )
                    .environmentObject(stateManager)
                    .transition(.move(edge: .trailing))
                }
            }
        }
    }
    
    var content: some View {
        GeometryReader { geometry in
            VStack {
                NavigationView {
                    ZStack {
                        // WelcomeQuestions view
                        VStack {
                            if animationStage >= 3 {
                                WelcomeQuestions(welcomeInput: $welcomeInput, firstName: $firstName, lastName: $lastName, selectedAge: $selectedAge, selectedLevel: $selectedLevel, selectedPosition: $selectedPosition)
                                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                                    .animation(.easeInOut(duration: 0.3), value: animationStage)
                            }
                        }
                        
                        // Bravo animation
                        RiveViewModel(fileName: "test_panting").view()
                            .frame(width: min(geometry.size.width * 0.6, 300), height: min(geometry.size.width * 0.6, 300))
                            .position(x: geometry.size.width / 2, 
                                     y: geometry.size.height * (animationStage >= 3 ? 0.25 : 0.45))
                            .offset(x: riveViewOffset.width, y: riveViewOffset.height)
                            .animation(.easeInOut(duration: 0.5), value: riveViewOffset)
                        
                        // Bravo messages
                        Text("Hello there, I'm Bravo! Let's help you become a more tekky player.")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, geometry.size.width * 0.1)
                            .position(x: geometry.size.width / 2, 
                                     y: geometry.size.height * 0.2)
                            .opacity(animationStage == 0 ? 1 : 0)
                            .font(.custom("Poppins-Bold", size: min(geometry.size.width * 0.045, 18)))
                        
                        Text("Enter your player details below")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .position(x: geometry.size.width * 0.7, 
                                     y: geometry.size.height * 0.15)
                            .opacity(animationStage >= 2 ? 1 : 0)
                            .font(.custom("Poppins-Bold", size: min(geometry.size.width * 0.045, 18)))
                        
                        // Back button
                        HStack {
                            Button(action: {
                                withAnimation {
                                    showWelcome = false
                                }
                            }) {
                                Image(systemName:"arrow.left")
                                    .font(.title2)
                                    .foregroundColor(globalSettings.primaryDarkColor)
                                    .padding()
                            }
                            .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.05)
                            
                            Spacer()
                        }
                        
                        // Bottom section
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(.white)
                                .frame(height: geometry.size.height * 0.15)
                            
                            Button(action: {
                                // Progress through animation stage for smooth transitions of Bravo avatar, message, and user input boxe
                                if animationStage < 3 {
                                    withAnimation(.spring(duration: 0.4)) {
                                        // Move the Rive animation up and to the left
                                        riveViewOffset = CGSize(width: -75, height: -250)
                                        animationStage = 1
                                    }
                                    
                                    // Delay showing the message
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            textOpacity2 = 1.0
                                            animationStage = 2
                                        }
                                    }
                                    
                                    // Delay showing the questionnaire
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            welcomeInput = 1
                                            animationStage = 3
                                        }
                                    }
                                } else if validateQ1() {
                                    withAnimation {
                                        showQuestionnaire = true // Transition to FirstQuestionnaireView
                                    }
                                }
                            }) {
                                Text("Next")
                                    .frame(maxWidth: geometry.size.width * 0.85)
                                    .frame(height: geometry.size.height * 0.06)
                                    .background(globalSettings.primaryYellowColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(20)
                                    .font(.custom("Poppins-Bold", size: min(geometry.size.width * 0.045, 18)))
                            }
                            .padding(.bottom, geometry.size.height * 0.0075)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .background(.white)
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
    // MARK: - (change to || for quick nav and && when done)
    // Validation function for Questionnaire 1
    private func validateQ1() -> Bool {
        if !firstName.isEmpty && 
           !lastName.isEmpty && 
           selectedAge != "Select your Age" && 
           selectedLevel != "Select your Level" && 
           selectedPosition != "Select your Position" {
            
            stateManager.updateWelcomeData(
                firstName: firstName,
                lastName: lastName,
                ageRange: selectedAge,
                level: selectedLevel,
                position: selectedPosition
            )
            return true
        }
        return false
    }
}


// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        Group {
            WelcomeView(
                isLoggedIn: .constant(false),
                showWelcome: .constant(false)
            )
            .environmentObject(stateManager)
            .previewDevice("iPhone 15 Pro Max")
            
            WelcomeView(
                isLoggedIn: .constant(false),
                showWelcome: .constant(false)
            )
            .environmentObject(stateManager)
            .previewDevice("iPhone SE (3rd generation)")
            
            WelcomeView(
                isLoggedIn: .constant(false),
                showWelcome: .constant(false)
            )
            .environmentObject(stateManager)
            .previewDevice("iPhone 14")
        }
    }
}
