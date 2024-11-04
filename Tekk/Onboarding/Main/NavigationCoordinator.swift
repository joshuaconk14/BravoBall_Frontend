//
//  NavigationCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

enum AppScreen {
    case onboarding
    case welcome
    case login
    case firstQuestionnaire
    case secondQuestionnaire
    case postOnboardingLoading
    case home
}

class NavigationCoordinator: ObservableObject {
    @Published var currentScreen: AppScreen = .onboarding
    @Published var navigationPath = NavigationPath()
    
    func navigate(to screen: AppScreen) {
        withAnimation(.spring()) {
            currentScreen = screen
        }
    }
    
    func goBack() {
        withAnimation(.spring()) {
            switch currentScreen {
            case .welcome:
                currentScreen = .onboarding
            case .login:
                currentScreen = .onboarding
            case .firstQuestionnaire:
                currentScreen = .welcome
            case .secondQuestionnaire:
                currentScreen = .firstQuestionnaire
            case .postOnboardingLoading:
                currentScreen = .secondQuestionnaire
            case .home:
                currentScreen = .onboarding
            case .onboarding:
                break
            }
        }
    }
}
