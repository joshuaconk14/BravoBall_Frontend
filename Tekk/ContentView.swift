//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//  This file contains the main view of the app.

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @StateObject private var stateManager = OnboardingStateManager()
    @State private var isLoggedIn: Bool = false
    @State private var authToken: String = ""
    @State private var showOnboarding: Bool = true

    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")] // Stores list of chat messages
    @State private var viewModel = ViewModel()
    @State private var conversations: [Conversation] = []
    @State private var activeTab: CameraView.Tab = .messages

    // Main parent view
    var body: some View {
        if isLoggedIn {
            TabView {
                // Main views of app
                ChatbotView(chatMessages: $chatMessages, authToken: $authToken, conversations: $conversations)
                    .tabItem {
                        Image(systemName: "message.fill")
                    }
                CameraView(image: $viewModel.currentFrame, activeTab: $activeTab)
                    .tabItem {
                        Image(systemName: "camera.fill")
                    }
                SettingsView()
                    .tabItem {
                        Image(systemName: "slider.horizontal.3")
                    }
            }
            .accentColor(globalSettings.primaryYellowColor)
        } else {
            OnboardingView(
                isLoggedIn: $isLoggedIn,
                authToken: $authToken,
                showOnboarding: $showOnboarding
            )
            .environmentObject(stateManager)
        }
    }
}


// for font ?
//init() {
//    for familyName in UIFont.familyNames {
//        print(familyName)
//        
//        for fontName in UIFont.fontNames(forFamilyName: familyName) {
//            print(fontName)
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}
