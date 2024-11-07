//
//  WelcomePage.swift
//  BravoBall
//
//  Created by Jordan on 11/5/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct WelcomePage: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
    @EnvironmentObject var bravoCoordinator: BravoCoordinator
    @EnvironmentObject var stateManager: OnboardingStateManager
    
    // Animation states
    @State private var animationStage = 0
    @State private var welcomeInput: Int = 0
    
    // Form states
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedAge: String = "Select your Age"
    @State private var selectedLevel: String = "Select your Level"
    @State private var selectedPosition: String = "Select your Position"
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Back button
                HStack {
                    Button(action: handleBack) {
                        Image(systemName:"arrow.left")
                            .font(.title2)
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top)
                
                if animationStage >= 3 {
                    // Questions form with Bravo to the side
                    ZStack {
                        // Bravo with gradient mask below
                        VStack {
                            BravoView(showMessage: true)
                            LinearGradient(
                                gradient: Gradient(colors: [.white, .clear]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .frame(height: 50)
                        }
                        
                        WelcomeQuestions(
                            welcomeInput: $welcomeInput,
                            firstName: $firstName,
                            lastName: $lastName,
                            selectedAge: $selectedAge,
                            selectedLevel: $selectedLevel,
                            selectedPosition: $selectedPosition
                        )
                        .padding(.top, 130)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                        .animation(.easeInOut(duration: 0.3), value: animationStage)
                    }
                } else {
                    Spacer()
                    BravoView(showMessage: true)
                    if animationStage == 0 {
                        Text(onboardingCoordinator.currentStep.bravoMessage)
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding(.horizontal, 80)
                            .multilineTextAlignment(.center)
                            .opacity(animationStage == 0 ? 1 : 0)
                            .animation(.easeOut(duration: 0.2), value: animationStage)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    Spacer()
                }
                
                // Next/Get Started button
                Button(action: handleNextButton) {
                    Text(animationStage >= 3 ? "Next" : "Get Started")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            setupInitialState()
        }
    }
    
    private func setupInitialState() {
        bravoCoordinator.centerBravo()
        bravoCoordinator.showMessage(onboardingCoordinator.currentStep.bravoMessage, duration: 0)
    }
    
    private func handleBack() {
        if animationStage >= 3 {
            withAnimation {
                animationStage = 0
                bravoCoordinator.centerBravo()
            }
        } else {
            onboardingCoordinator.moveToPrevious()
        }
    }
    
    private func handleNextButton() {
        if animationStage < 3 {
            animateToQuestions()
        } else if validateForm() {
            stateManager.updateWelcomeData(
                firstName: firstName,
                lastName: lastName,
                ageRange: selectedAge,
                level: selectedLevel,
                position: selectedPosition
            )
            onboardingCoordinator.moveToNext()
        }
    }
    
    private func animateToQuestions() {
        withAnimation(.spring(duration: 0.4)) {
            bravoCoordinator.moveToSide()
            animationStage = 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                animationStage = 2
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeInOut(duration: 0.3)) {
                welcomeInput = 1
                animationStage = 3
            }
        }
    }
    
    private func validateForm() -> Bool {
        return !firstName.isEmpty && 
               !lastName.isEmpty && 
               selectedAge != "Select your Age" && 
               selectedLevel != "Select your Level" && 
               selectedPosition != "Select your Position"
    }
}

#Preview {
    WelcomePage()
        .environmentObject(OnboardingCoordinator())
        .environmentObject(BravoCoordinator())
}
