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
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(isLoggedIn: $isLoggedIn, authToken: $authToken)
        }
    }
}
