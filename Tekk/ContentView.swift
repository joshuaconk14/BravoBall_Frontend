//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//  This file contains the main view of the app.

import SwiftUI
import RiveRuntime
//import GoogleGenerativeAI


struct ContentView: View {
    @State private var isLoggedIn = false // Track if user is logged in
    @State private var token: String? = nil // Store the JWT token
    @State private var messageText = "" // Current text input from user
    @State private var authToken = ""
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
            .accentColor(.green)
        } else {
            PlayerDetailsFormView(isLoggedIn: $isLoggedIn, onDetailsSubmitted: {
                self.isLoggedIn = true
            })
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
