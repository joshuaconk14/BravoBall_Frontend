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
    @StateObject var appModel = MainAppModel()
    @StateObject var userInfoManager = UserManager()

    var body: some View {
        Group {
            if onboardingModel.isLoggedIn {
                MainTabView(model: onboardingModel, mainAppModel: appModel, userManager: userInfoManager)
            } else {
                OnboardingView(model: onboardingModel, mainAppModel: appModel, userManager: userInfoManager)
            }
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
