//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//  This file contains the main view of the app.

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var stateManager = OnboardingStateManager()
    @StateObject private var navigator = NavigationCoordinator()
    @State private var authToken: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch navigator.currentScreen {
                case .onboarding:
                    OnboardingView()
                case .welcome:
                    WelcomeView()
                case .login:
                    LoginView()
                case .firstQuestionnaire:
                    FirstQuestionnaireView()
                case .secondQuestionnaire:
                    SecondQuestionnaireView()
                case .postOnboardingLoading:
                    PostOnboardingLoadingView(onboardingData: stateManager.onboardingData)
                case .home:
                    MainTabView(authToken: authToken)                }
            }
            .environmentObject(stateManager)
            .environmentObject(navigator)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
