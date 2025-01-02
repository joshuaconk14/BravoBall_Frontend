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
    @State private var conversations: [Conversation] = []
    @Binding var authToken: String
    
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
            SettingsView()
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
        MainTabView(authToken: .constant("preview-token"))
    }
}
