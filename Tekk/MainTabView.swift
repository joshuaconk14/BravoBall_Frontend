//
//  MainTabView.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct MainTabView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
    @State private var viewModel = ViewModel()
    @State private var conversations: [Conversation] = []
    @State private var activeTab: CameraView.Tab = .messages
    @Binding var authToken: String
    
    var body: some View {
        TabView {
            HomeProgramView()  // Add this new view
                    .tabItem {
                        Image(systemName: "figure.run")
                    }
//            ChatbotView(chatMessages: $chatMessages, authToken: $authToken, conversations: $conversations)
//                .tabItem {
//                    Image(systemName: "message.fill")
//                }
//            CameraView(image: $viewModel.currentFrame, activeTab: $activeTab)
//                .tabItem {
//                    Image(systemName: "camera.fill")
//                }
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                }
        }
        .accentColor(globalSettings.primaryYellowColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authToken: .constant("preview-token"))
    }
}
