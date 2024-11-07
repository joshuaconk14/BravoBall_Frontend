//
//  NavigationCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

enum AppScreen {
    case splash
    case welcome
    case onboardingFlow
    case home
}

class NavigationCoordinator: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
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
                currentScreen = .splash
            case .onboardingFlow:
                currentScreen = .welcome
            case .home:
                currentScreen = .onboardingFlow
            case .splash:
                break
            }
        }
    }
}
