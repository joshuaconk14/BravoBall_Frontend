////
////  ContentView.swift
////  Tekk
////
////  Created by Jordan on 7/9/24.
////  This file contains the main view of the app.

import SwiftUI

@main
struct BravoBallApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    @StateObject private var onboardingModel = OnboardingModel()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
                    .environmentObject(onboardingModel)
            } else {
                OnboardingView()
                    .environmentObject(onboardingModel)
                    .onDisappear {
                        hasCompletedOnboarding = true
                    }
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
