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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateManager)
        }
    }
}

struct BravoBall_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        ContentView()
            .environmentObject(stateManager)
            .previewDisplayName("Main App Preview")
    }
}
