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
    @StateObject var onboardingModel = OnboardingModel()

    var body: some View {
        Group {
            if onboardingModel.isLoggedIn {
                MainTabView(model: onboardingModel)
            } else {
                OnboardingView(model: onboardingModel)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
