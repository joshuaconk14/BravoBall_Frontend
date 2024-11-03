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
    @State private var isLoading = true
    @State private var showNextScreen = false
    @State private var errorMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    let onboardingData: OnboardingData
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if isLoading {
                    // You can replace this with your Rive animation
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
        .fullScreenCover(isPresented: $showNextScreen) {
            // Instead of creating a new ContentView, just set isLoggedIn
            Color.clear.onAppear {
                isLoggedIn = true
            }
        }
    }
    
    private func submitData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                try await OnboardingService.shared.submitOnboardingData(data: onboardingData)
                DispatchQueue.main.async {
                    isLoading = false
                    showNextScreen = true
                }
                print("✅ Onboarding data submitted successfully")
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    errorMessage = "Something went wrong. Please try again."
                }
                print("❌ Error submitting onboarding data: \(error)")
            }
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
        
        PostOnboardingLoadingView(onboardingData: sampleData, isLoggedIn: .constant(false))
            .environmentObject(stateManager)
    }
}
