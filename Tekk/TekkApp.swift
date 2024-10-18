//
//  TekkApp.swift
//  Tekk
//
//  Created by Joshua Conklin on 10/3/24.
//
import SwiftUI
import RiveRuntime

@main
struct TekkApp: App {
    @State private var isLoggedIn: Bool = false
    @State private var authToken: String = ""
    @State private var showOnboarding = true
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(isLoggedIn: $isLoggedIn, authToken: $authToken, showOnboarding: $showOnboarding)
        }
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Use constant bindings for preview
//        OnboardingView(isLoggedIn: .constant(false),
//                       authToken: .constant(""),
//                       showOnboarding: .constant(true))
//    }
//}
