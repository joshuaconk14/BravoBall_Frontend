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
    @ObservedObject var sessionModel: SessionGeneratorModel

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Main Content
                ZStack {
                    switch appModel.mainTabSelected {
                    case 0:
                        SessionGeneratorView(model: model, appModel: appModel, sessionModel: sessionModel)
                    case 1:
                        ProgressionView(appModel: appModel, sessionModel: sessionModel)
                    case 2:
                        SavedDrillsView(appModel: appModel, sessionModel: sessionModel)
                    case 3:
                        ProfileView(model: model, appModel: appModel, userManager: userManager)
                    default:
                        SessionGeneratorView(model: model, appModel: appModel, sessionModel: sessionModel)
                    }
                }
                
                // Custom Tab Bar
                HStack(spacing: 0) {
                    CustomTabItem(
                        icon: AnyView(appModel.homeTab.view()),
                        isSelected: appModel.mainTabSelected == 0
                    ) {
                        appModel.mainTabSelected = 0
                    }
                    
                    CustomTabItem(
                        icon: AnyView(appModel.progressTab.view()),
                        isSelected: appModel.mainTabSelected == 1
                    ) {
                        appModel.mainTabSelected = 1
                    }
                    
                    CustomTabItem(
                        icon: AnyView(appModel.savedTab.view()),
                        isSelected: appModel.mainTabSelected == 2
                    ) {
                        appModel.mainTabSelected = 2
                    }
                    
                    CustomTabItem(
                        icon: AnyView(appModel.profileTab.view()),
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
    // 1. Create required services
    let encryption = try! EncryptionService()  // Force try for preview
    let secureStorage = SecureStorageService(encryption: encryption)
    
    // 2. Create models with dependencies
    let mockOnboardingModel = OnboardingModel()
    let mockMainAppModel = MainAppModel()
    let mockUserManager = UserManager()
    
    // 3. Create proper onboarding data
    let mockOnboardingData = OnboardingModel.OnboardingData(
        trainingExperience: "Beginner",
        trainingLocation: ["field with goals"],
        availableEquipment: ["balls", "cones"],
        dailyTrainingTime: "30-60 minutes"
    )
    
    // 4. Create session model with dependencies
    let mockSesGenModel = SessionGeneratorModel(
        onboardingData: mockOnboardingData,
        secureStorage: secureStorage
    )
    
    // 5. Set onboarding data
    mockOnboardingModel.onboardingData = mockOnboardingData
    
    return MainTabView(
        model: mockOnboardingModel,
        appModel: mockMainAppModel,
        userManager: mockUserManager,
        sessionModel: mockSesGenModel
    )
}
