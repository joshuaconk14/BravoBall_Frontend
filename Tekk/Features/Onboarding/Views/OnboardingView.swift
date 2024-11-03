//
//  OnboardingView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 9/30/24.//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    
    @Binding var isLoggedIn: Bool
    @Binding var authToken: String
    @State private var showLoginPage = false // State to control login page visibility
    @State private var showWelcome = false
    @State private var showIntroAnimation = true
    @Binding var showOnboarding: Bool
    // var for "welcome" matchedGeometry function
    @Namespace var welcomeSpace
    // var for private showIntroAnimation scale (so it doesn't affect other elements
    @State private var animationScale: CGFloat = 1.5
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // Main content (Bravo and buttons)
            if !showWelcome && !showLoginPage {
                content
            }
            
            // Login view with transition
            if showLoginPage {
                LoginView(isLoggedIn: $isLoggedIn, 
                         authToken: $authToken, 
                         showLoginPage: $showLoginPage)
                    .transition(.move(edge: .bottom))
            }
            
            // Welcome view with transition
            if showWelcome {
                WelcomeView(
                    isLoggedIn: $isLoggedIn,
                    showWelcome: $showWelcome
                )
                .environmentObject(stateManager)
                .transition(.move(edge: .trailing))
            }
            
            // Intro animation overlay
            if showIntroAnimation {
                RiveViewModel(fileName: "tekk_intro").view()
                    .scaleEffect(animationScale)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) {
                            showIntroAnimation = false
                        }
                    }
            }
        }
        .animation(.spring(), value: showWelcome)
        .animation(.spring(), value: showLoginPage)
    }
    var content: some View {
        VStack {
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 300, height: 300)
                .padding(.top, 30)
                .padding(.bottom, 10)
            Text("BravoBall")
                .foregroundColor(globalSettings.primaryYellowColor)
                .padding(.bottom, 5)
                .font(.custom("PottaOne-Regular", size: 45))
            
            Text("Start Small. Dream Big")
                .foregroundColor(Color(hex:"1E272E"))
                .padding(.bottom, 100)
                .font(.custom("Poppins-Bold", size: 16))
            
            // transition to WelcomeView
            Button(action: {
                withAnimation(.spring()) {
                    showWelcome.toggle()
                }
            }) {
                Text("Create an account")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            // lets get tekky button padding to move it down
            .padding(.horizontal)
            .padding(.top, 80)
            
            // transition to login page
            Button(action: {
                withAnimation(.spring()) {
                    showLoginPage = true
                }
            }) {
                Text("Login")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            
            Spacer()
            
        }
        .padding()
        .background(.white)
    }
}


// Preview canvas

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        OnboardingView(
            isLoggedIn: .constant(false),
            authToken: .constant(""),
            showOnboarding: .constant(true)
        )
        .environmentObject(stateManager)
    }
}
