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
    @EnvironmentObject var stateManager: OnboardingStateManager
    @State private var navigateToHome = false
    @State private var error: Error?
    @State private var showRegisterView = false
    
    let onboardingData: OnboardingData
    @Binding var isLoggedIn: Bool
    
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
                            showRegisterView = true
                        }
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .fullScreenCover(isPresented: $showRegisterView) {
                            RegisterView(
                                isLoggedIn: $isLoggedIn, onDetailsSubmitted: {} )
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            submitData()
        }
        .onChange(of: navigateToHome) { _, newValue in
            if newValue {
                isLoggedIn = true
            }
        }
    }
    
    private func submitData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Debug print to see what data we're sending
                print("📤 Sending onboarding data: \(onboardingData)")
                
                // Submit onboarding data to the backend
                let response = try await OnboardingService.shared.submitOnboardingData(data: onboardingData)
                print("✅ Onboarding data submitted successfully")
                
                await MainActor.run {
                    // Store access token taking access token response from the backend response
                    UserDefaults.standard.set(response.access_token, forKey: "accessToken")
                    
                    // Update drills in ViewModel
                    DrillsViewModel.shared.recommendedDrills = response.recommendations
                    
                    isLoading = false
                    navigateToHome = true
                }
            } catch let error as NSError {
                await MainActor.run {
                    isLoading = false
                    // More detailed error message
                    errorMessage = "Server Error (\(error.code)): \(error.localizedDescription)"
                    print("❌ Detailed error: \(error)")
                    print("❌ Error domain: \(error.domain)")
                    print("❌ Error code: \(error.code)")
                    print("❌ Error user info: \(error.userInfo)")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    errorMessage = "Error: \(error.localizedDescription)"
                    print("❌ Error submitting onboarding data: \(error)")
                }
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
            email: "jdoe@gmail.com",
            password: "imjohndoe",
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
            trainingDays: ["Monday", "Wednesday"],
            availableEquipment: ["Ball", "Cones"]
        )
        
        PostOnboardingLoadingView(
            onboardingData: sampleData,
            isLoggedIn: .constant(false)
        )
        .environmentObject(stateManager)
    }
}
