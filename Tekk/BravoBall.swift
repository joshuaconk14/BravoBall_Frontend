//
//  BravoBall.swift
//  BravoBall
//
//  Created by Joshua Conklin on 10/3/24.
//
// BravoBall (Entry)
// └── ContentView (Root)
//     ├── TabView (main app view, if isLoggedIn)
//     └── OnboardingView (onboarding flow, if !isLoggedIn)
//         └── ... (rest of onboarding flow)

import SwiftUI
import RiveRuntime

@main
struct BravoBall: App {
    @StateObject private var stateManager = OnboardingStateManager()
    @StateObject private var onboardingCoordinator = OnboardingCoordinator()
    @StateObject private var bravoCoordinator = BravoCoordinator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateManager)
                .environmentObject(onboardingCoordinator)
                .environmentObject(bravoCoordinator)
        }
    }
}

struct BravoBall_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let onboardingCoordinator = OnboardingCoordinator()
        let bravoCoordinator = BravoCoordinator()
        
        ContentView()
            .environmentObject(stateManager)
            .environmentObject(onboardingCoordinator)
            .environmentObject(bravoCoordinator)
            .previewDisplayName("Main App Preview")
    }
}
