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
    @ObservedObject var mainAppModel: MainAppModel
    @ObservedObject var userManager: UserManager
    
    var body: some View {
        TabView(selection: $mainAppModel.mainTabSelected) {
            SessionGeneratorView(model: model)
                .tabItem {
                    Image(systemName: "figure.soccer")
                    Text("Train")
                }
                .tag(0)
            CompletedSessionView(mainAppModel: mainAppModel)
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
            
            ProfileView(model: model, mainAppModel: mainAppModel, userManager: userManager)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(3)
        }
        .accentColor(model.globalSettings.primaryYellowColor)
        .onAppear {
            mainAppModel.mainTabSelected = 0
        }
    }
}

#Preview {
    let mockOnboardingModel = OnboardingModel()
    let mockMainAppModel = MainAppModel()
    let mockUserManager = UserManager()
    
    return MainTabView(
        model: mockOnboardingModel,
        mainAppModel: mockMainAppModel,
        userManager: mockUserManager
    )
}
