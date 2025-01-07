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
    @EnvironmentObject var stateManager: OnboardingStateManager
    
    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
    @State private var viewModel = ViewModel()
    @State private var conversations: [Conversation] = []
    @State private var activeTab: CameraView.Tab = .messages
    @Binding var authToken: String
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        TabView {
            RecommendedDrillsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("For You")
                }
            
            HomeProgramView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Program")
                }
            
//            DrillCatalogView()
//                .tabItem {
//                    Image(systemName: "book.fill")
//                    Text("Drills")
//                }
//            
            SettingsView(isLoggedIn: $isLoggedIn)
                .environmentObject(stateManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(globalSettings.primaryYellowColor)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        
        // Set up mock data for preview
        stateManager.updateRegister(
            firstName: "Jordan",
            lastName: "Conklin",
            email: "jordinhoconk@gmail.com",
            password: "password123"
        )
        
        return Group {
            MainTabView(
                authToken: .constant("preview-token"),
                isLoggedIn: .constant(true)
            )
            .environmentObject(stateManager)
            .previewDisplayName("Light Mode")
            
            MainTabView(
                authToken: .constant("preview-token"),
                isLoggedIn: .constant(true)
            )
            .environmentObject(stateManager)
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
