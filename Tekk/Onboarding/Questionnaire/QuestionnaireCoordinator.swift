//
//  QuestionnaireCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

enum QuestionnaireStep: Identifiable {
    // First Questionnaire
    case playerSelection
    case strengthSelection
    case weaknessSelection
    // Second Questionnaire
    case teamStatus
    case goalSelection
    case timelineSelection
    case trainingLevel
    case trainingDays
    
    var id: Int {
        switch self {
        case .playerSelection: return 0
        case .strengthSelection: return 1
        case .weaknessSelection: return 2
        case .teamStatus: return 3
        case .goalSelection: return 4
        case .timelineSelection: return 5
        case .trainingLevel: return 6
        case .trainingDays: return 7
        }
    }
    
    var bravoMessage: String {
        switch self {
        case .playerSelection:
            return "Nice! I know so much more about you now! Just a few questions to know your style of play."
        case .strengthSelection:
            return "Great choices! Now let's identify your strengths."
        // Add messages for other steps
        case .teamStatus:
            return "Now let's get to know more about your team situation!"
        default:
            return ""
        }
    }
}

class QuestionnaireCoordinator: ObservableObject {
    @Published var currentStep: QuestionnaireStep = .playerSelection
    @Published var direction: NavigationDirection = .forward
    @Published var showBravoAnimation: Bool = false
    @Published var riveViewOffset: CGSize = .zero
    
    enum NavigationDirection {
        case forward
        case backward
    }
    
    func moveToNext() {
        direction = .forward
        switch currentStep {
        case .playerSelection:
            currentStep = .strengthSelection
        case .strengthSelection:
            currentStep = .weaknessSelection
        case .weaknessSelection:
            showBravoTransition()
            currentStep = .teamStatus
        case .teamStatus:
            currentStep = .goalSelection
        case .goalSelection:
            currentStep = .timelineSelection
        case .timelineSelection:
            currentStep = .trainingLevel
        case .trainingLevel:
            currentStep = .trainingDays
        case .trainingDays:
            break
        }
    }
    
    func moveToPrevious() {
        direction = .backward
        switch currentStep {
        case .playerSelection:
            break
        case .strengthSelection:
            currentStep = .playerSelection
        case .weaknessSelection:
            currentStep = .strengthSelection
        case .teamStatus:
            showBravoTransition()
            currentStep = .weaknessSelection
        case .goalSelection:
            currentStep = .teamStatus
        case .timelineSelection:
            currentStep = .goalSelection
        case .trainingLevel:
            currentStep = .timelineSelection
        case .trainingDays:
            currentStep = .trainingLevel
        }
    }
    
    private func showBravoTransition() {
        showBravoAnimation = true
        withAnimation(.spring()) {
            riveViewOffset = CGSize(width: -75, height: -250)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                self.showBravoAnimation = false
                self.riveViewOffset = .zero
            }
        }
    }
}
