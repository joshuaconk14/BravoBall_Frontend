//
//  MainTabView.swift
//  BravoBall
//
//  Created by Jordan on 1/6/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @ObservedObject var model: OnboardingModel
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SessionGeneratorView(model: model)
                .tabItem {
                    Image(systemName: "figure.soccer")
                    Text("Train")
                }
                .tag(0)
            
            SavedDrillsView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
                .tag(2)
            
            ProfileView(model: model)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(model.globalSettings.primaryYellowColor)
    }
}

