//
//  BravoBall.swift
//  BravoBall
//
//  Created by Joshua Conklin on 10/3/24.
//
import SwiftUI
import RiveRuntime

@main
struct BravoBall: App {
    @StateObject private var stateManager = OnboardingStateManager()
    
    @State private var isLoggedIn: Bool = false
    @State private var authToken: String = ""
    @State private var showOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(isLoggedIn: $isLoggedIn, authToken: $authToken, showOnboarding: $showOnboarding)
                .environmentObject(stateManager)
        }
    }
}

struct BravoBall_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        OnboardingView(
            isLoggedIn: .constant(false),
            authToken: .constant(""),
            showOnboarding: .constant(true)
        )
        .environmentObject(stateManager)
        .previewDisplayName("Main App Preview")
    }
}
