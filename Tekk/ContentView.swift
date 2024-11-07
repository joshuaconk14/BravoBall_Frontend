//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//  This file contains the main view of the app.

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var onboardingCoordinator = OnboardingCoordinator()
    @StateObject private var bravoCoordinator = BravoCoordinator()
    @StateObject private var stateManager = OnboardingStateManager()
    
    var body: some View {
        ZStack {
            switch onboardingCoordinator.currentStep {
            case .splash:
                SplashView()
            case .welcome:
                WelcomePage()
            case .playerStyle, .strengths, .weaknesses,
                 .teamStatus, .goals, .timeline,
                 .trainingLevel, .trainingDays:
                OnboardingFlowView()
            case .completion:
                // Replace with your home view
                Text("Welcome to BravoBall!")
            }
        }
        .environmentObject(onboardingCoordinator)
        .environmentObject(bravoCoordinator)
        .environmentObject(stateManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
