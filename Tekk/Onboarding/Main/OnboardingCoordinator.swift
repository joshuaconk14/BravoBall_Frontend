//
//  OnboardingCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

enum OnboardingStep: Identifiable {
    case splash
    case welcome
    case playerStyle
    case strengths
    case weaknesses
    case teamStatus
    case goals
    case timeline
    case trainingLevel
    case trainingDays
    case completion
    
    var id: String { String(describing: self) }
    
    var bravoMessage: String {
        switch self {
        case .splash:
            return "Hello there, I'm Bravo! Let's help you become a more tekky player."
        case .welcome:
            return "Let's get to know each other better!"
        case .playerStyle:
            return "Nice! I know so much more about you now! Just a few questions to know your style of play."
        case .strengths:
            return "Great choices! Now let's identify your strengths."
        case .weaknesses:
            return "What would you like to work on?"
        case .teamStatus:
            return "Now let's get to know more about your team situation!"
        case .goals:
            return "What are your goals?"
        case .timeline:
            return "When do you want to achieve these goals?"
        case .trainingLevel:
            return "Let's set up your training schedule!"
        case .trainingDays:
            return "Which days work best for you?"
        case .completion:
            return "Great! I'm excited to help you improve!"
        }
    }
}

class OnboardingCoordinator: ObservableObject {
    @Published var currentStep: OnboardingStep = .splash
    @Published var direction: NavigationDirection = .forward
    @Published var showBravoAnimation: Bool = false
    @Published var riveViewOffset: CGSize = .zero
    
    enum NavigationDirection {
        case forward
        case backward
    }
    
    func moveToNext() {
        direction = .forward
        withAnimation(.easeInOut) {
            switch currentStep {
            case .splash: currentStep = .welcome
            case .welcome: currentStep = .playerStyle
            case .playerStyle: currentStep = .strengths
            case .strengths: currentStep = .weaknesses
            case .weaknesses:
                showBravoTransition()
                currentStep = .teamStatus
            case .teamStatus: currentStep = .goals
            case .goals: currentStep = .timeline
            case .timeline: currentStep = .trainingLevel
            case .trainingLevel: currentStep = .trainingDays
            case .trainingDays: currentStep = .completion
            case .completion: break
            }
        }
    }
    
    func moveToPrevious() {
        direction = .backward
        withAnimation(.easeInOut) {
            switch currentStep {
            case .splash: break
            case .welcome: currentStep = .splash
            case .playerStyle: currentStep = .welcome
            case .strengths: currentStep = .playerStyle
            case .weaknesses: currentStep = .strengths
            case .teamStatus:
                showBravoTransition()
                currentStep = .weaknesses
            case .goals: currentStep = .teamStatus
            case .timeline: currentStep = .goals
            case .trainingLevel: currentStep = .timeline
            case .trainingDays: currentStep = .trainingLevel
            case .completion: currentStep = .trainingDays
            }
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
