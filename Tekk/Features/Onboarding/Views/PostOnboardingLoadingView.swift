//
//  PostOnboardingLoadingView.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct PostOnboardingLoadingView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var navigator: NavigationCoordinator
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    let onboardingData: OnboardingData
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: globalSettings.primaryYellowColor))
                    
                    Text("Creating your personalized training plan...")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 20)
                } else if let error = errorMessage {
                    VStack(spacing: 20) {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Try Again") {
                            submitData()
                        }
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            submitData()
        }
    }
    
    private func submitData() {
        isLoading = true
        errorMessage = nil
        
        // Simulate API call with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Navigate to home screen
            navigator.navigate(to: .home)
        }
    }
}


// MARK: - Preview
struct PostOnboardingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let sampleData = OnboardingData(
            firstName: "John",
            lastName: "Doe",
            ageRange: "Teen (13-16)",
            level: "Beginner",
            position: "Forward",
            playstyleRepresentatives: ["Player 1", "Player 2"],
            strengths: ["Shooting", "Dribbling"],
            weaknesses: ["Passing", "Defense"],
            hasTeam: true,
            primaryGoal: "Be the best player",
            timeline: "Within 1 year",
            skillLevel: "Intermediate",
            trainingDays: ["Monday", "Wednesday"]
        )
        
        PostOnboardingLoadingView(onboardingData: sampleData)
            .environmentObject(stateManager)
    }
}
