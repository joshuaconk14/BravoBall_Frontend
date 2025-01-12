//
//  CompletionView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime

struct CompletionView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var userManager: UserManager
    
    
    var body: some View {
        VStack(spacing: 20) {
            Image("BravoBallDog") // Replace with your actual mascot image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Creating your personalized training plan...")
                .font(.headline)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
            Button(action: {
                withAnimation(.spring()) {
                    model.isLoggedIn = true
                    model.resetOnboardingData()
                }
            }) {
                Text("Get Started")
                    .frame(width: 200)
                    .frame(height: 44)
                    .background(model.globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        .padding()
        .onAppear {
            submitData()
        }
    }
    
    func submitData() {
            
        Task {
            do {
                print("📤 Sending onboarding data: \(model.onboardingData)")
                
                // Run the OnboardingService function to submit data
                let response = try await OnboardingService.shared.submitOnboardingData(data: model.onboardingData)
                print("✅ Onboarding data submitted successfully")
                
                await MainActor.run {
                    // Store access token taking access token response from the backend response
                    UserDefaults.standard.set(response.access_token, forKey: "accessToken")
                    
                    // Update the decoded user info into UserManager, which will store it into Keychain
                    userManager.updateUserKeychain(
                        email: model.onboardingData.email,
                        firstName: model.onboardingData.firstName,
                        lastName: model.onboardingData.lastName
                    )
                    
                    print("Data submitted")
                    print("Access token: \(response.access_token)")
                    print("Email: \(model.onboardingData.email)")
                    print("First Name: \(model.onboardingData.firstName)")
                    print("Last Name: \(model.onboardingData.lastName)")
                    
                    
                }
            } catch let error as NSError {
                await MainActor.run {
                    model.errorMessage = "Server Error (\(error.code)): \(error.localizedDescription)"
                    print("❌ Detailed error: \(error)")
                    print("❌ Error domain: \(error.domain)")
                    print("❌ Error code: \(error.code)")
                    print("❌ Error user info: \(error.userInfo)")
                }
            } catch {
                await MainActor.run {
                    model.errorMessage = "Error: \(error.localizedDescription)"
                    print("❌ Error submitting onboarding data: \(error)")
                }
            }
        }
    }
}

