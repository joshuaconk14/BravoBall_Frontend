//
//  MainTabView.swift
//  BravoBall
//
//  Created by Jordan on 1/6/25.
//

import Foundation
import SwiftUI
import RiveRuntime

struct MainTabView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var userManager: UserManager
    @StateObject private var homeTab = RiveViewModel(fileName: "Tab_House")
    @StateObject private var progressTab = RiveViewModel(fileName: "Tab_Calendar")
    @StateObject private var savedTab = RiveViewModel(fileName: "Tab_Saved")
    @StateObject private var profileTab = RiveViewModel(fileName: "Tab_Dude")
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main Content
            ZStack {
                switch appModel.mainTabSelected {
                case 0:
                    SessionGeneratorView(model: model, appModel: appModel)
                case 1:
                    ProgressionView(appModel: appModel)
                case 2:
                    SavedDrillsView()
                case 3:
                    ProfileView(model: model, appModel: appModel, userManager: userManager)
                default:
                    SessionGeneratorView(model: model, appModel: appModel)
                }
            }
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                CustomTabItem(
                    icon: AnyView(homeTab.view()),
                    isSelected: appModel.mainTabSelected == 0
                ) {
                    appModel.mainTabSelected = 0
                }
                
                CustomTabItem(
                    icon: AnyView(progressTab.view()),
                    isSelected: appModel.mainTabSelected == 1
                ) {
                    appModel.mainTabSelected = 1
                }
                
                CustomTabItem(
                    icon: AnyView(savedTab.view()),
                    isSelected: appModel.mainTabSelected == 2
                ) {
                    appModel.mainTabSelected = 2
                }
                
                CustomTabItem(
                    icon: AnyView(profileTab.view()),
                    isSelected: appModel.mainTabSelected == 3
                ) {
                    appModel.mainTabSelected = 3
                }
            }
            .padding(.horizontal)
            .padding(.top, 18)
            .background(
                VStack(spacing: 0) {
                    Divider()
                        .frame(height: 3)
                        .background(Color.gray.opacity(0.3))
                    Color.white
                }
                .ignoresSafeArea()
            )
        }
    }
}

struct CustomTabItem: View {
    let icon: AnyView
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                icon
                    .frame(width: 30, height: 30)
                    .scaleEffect(isSelected ? 1.5 : 1.0)
            }
            .frame(maxWidth: .infinity)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
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
