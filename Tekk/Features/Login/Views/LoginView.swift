//
//  LoginView.swift
//  BravoBall
//
//  Created by Jordan on 8/26/24.
//  This file contains the LoginView, which is used to login the user.

import SwiftUI
import RiveRuntime

struct LoginView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
    @EnvironmentObject var bravoCoordinator: BravoCoordinator
    @EnvironmentObject var stateManager: OnboardingStateManager
    
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Back button
                HStack {
                    Button(action: handleBack) {
                        Image(systemName: "arrow.left")
                            .font(.title2)
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .padding()
                    }
                    Spacer()
                }
                
                // Bravo and Title
                BravoView()
                    .frame(width: 200, height: 200)
                    .padding(.top, 20)
                
                Text("Welcome Back!")
                    .font(.custom("PottaOne-Regular", size: 32))
                    .foregroundColor(globalSettings.primaryYellowColor)
                    .padding(.bottom, 40)
                
                // Login Form
                VStack(spacing: 20) {
                    // Email Field
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 325)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .frame(width: 325)
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.custom("Poppins-Regular", size: 14))
                    }
                    
                    Button(action: handleLogin) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
                    .disabled(isLoading)
                    
                    Button(action: handleForgotPassword) {
                        Text("Forgot Password?")
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .font(.custom("Poppins-Regular", size: 14))
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Sign up prompt
                HStack {
                    Text("Don't have an account?")
                        .font(.custom("Poppins-Regular", size: 14))
                    Button(action: handleSignUp) {
                        Text("Sign Up")
                            .foregroundColor(globalSettings.primaryYellowColor)
                            .font(.custom("Poppins-Bold", size: 14))
                    }
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
        bravoCoordinator.showMessage("Welcome back! Ready to train?", duration: 0)
    }
    
    private func handleBack() {
        onboardingCoordinator.moveToPrevious()
    }
    
    private func handleLogin() {
        isLoading = true
        showError = false
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            // Add your login logic here
            if email.isEmpty || password.isEmpty {
                showError = true
                errorMessage = "Please fill in all fields"
            } else {
                onboardingCoordinator.moveToNext()
            }
        }
    }
    
    private func handleForgotPassword() {
        // Add forgot password logic
    }
    
    private func handleSignUp() {
        // Add sign up navigation logic
    }
}

#Preview {
    LoginView()
        .environmentObject(OnboardingCoordinator())
        .environmentObject(BravoCoordinator())
        .environmentObject(OnboardingStateManager())
}
