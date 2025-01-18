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
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        TabView(selection: $appModel.mainTabSelected) {
            SessionGeneratorView(model: model)
                .tabItem {
                    Image(systemName: "figure.soccer")
                    Text("Train")
                }
                .tag(0)
            ProgressionView(appModel: appModel)
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Sessions")
                }
                .tag(1)
            
            SavedDrillsView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Saved")
                }
                .tag(2)
            
            ProfileView(model: model, appModel: appModel, userManager: userManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(model.globalSettings.primaryYellowColor)
        .onAppear {
            appModel.mainTabSelected = 0
        UITabBar.appearance().backgroundColor = .white
        }
    }
}

#Preview {
    let mockOnboardingModel = OnboardingModel()
    let mockMainAppModel = MainAppModel()
    let mockUserManager = UserManager()
    
    return MainTabView(
        model: mockOnboardingModel,
        appModel: mockMainAppModel,
        userManager: mockUserManager
    )
}
