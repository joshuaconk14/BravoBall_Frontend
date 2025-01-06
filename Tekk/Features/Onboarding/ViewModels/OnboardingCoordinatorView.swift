//
//  OnboardingCoordinatorView.swift
//  BravoBall
//
//  Created by Jordan on 1/6/25.
//

import Foundation
import SwiftUI

enum OnboardingStep: Hashable {
    case welcome
    case firstQuestionnaire
    case secondQuestionnaire
    case loading
}

class OnboardingCoordinator: ObservableObject {
    @Published var navigationPath = NavigationPath()
    @Published var canNavigateBack = false
    
    func navigateToStep(_ step: OnboardingStep) {
        navigationPath.append(step)
        updateNavigationState()
    }
    
    func navigateBack() {
        navigationPath.removeLast()
        updateNavigationState()
    }
    
    func resetNavigation() {
        navigationPath = NavigationPath()
        updateNavigationState()
    }
    
    private func updateNavigationState() {
        canNavigateBack = !navigationPath.isEmpty
    }
}
