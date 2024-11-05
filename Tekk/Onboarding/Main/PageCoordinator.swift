//
//  PageCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

enum OnboardingPage: Identifiable {
    case splash
    case welcome
    case personalInfo
    case playerStyle
    case strengths
    case weaknesses
    case teamStatus
    case goals
    case timeline
    case trainingPreferences
    case completion
    
    var id: String { String(describing: self) }
    
    var bravoMessage: String {
        switch self {
        case .splash:
            return "Hello there, I'm Bravo! Let's help you become a more tekky player."
        case .welcome:
            return "Let's get to know each other better!"
        case .personalInfo:
            return "Tell me a bit about yourself!"
        case .playerStyle:
            return "Which players inspire your style?"
        case .strengths:
            return "What are your biggest strengths?"
        case .weaknesses:
            return "What would you like to work on?"
        case .teamStatus:
            return "Are you currently playing on a team?"
        case .goals:
            return "What are your goals?"
        case .timeline:
            return "When do you want to achieve these goals?"
        case .trainingPreferences:
            return "Let's set up your training schedule!"
        case .completion:
            return "Great! I'm excited to help you improve!"
        }
    }
}

class PageCoordinator: ObservableObject {
    @Published var currentPage: OnboardingPage = .splash
    @Published var direction: NavigationDirection = .forward
    
    enum NavigationDirection {
        case forward
        case backward
    }
    
    func moveToNext() {
        direction = .forward
        withAnimation(.easeInOut) {
            switch currentPage {
            case .splash: currentPage = .welcome
            case .welcome: currentPage = .personalInfo
            case .personalInfo: currentPage = .playerStyle
            case .playerStyle: currentPage = .strengths
            case .strengths: currentPage = .weaknesses
            case .weaknesses: currentPage = .teamStatus
            case .teamStatus: currentPage = .goals
            case .goals: currentPage = .timeline
            case .timeline: currentPage = .trainingPreferences
            case .trainingPreferences: currentPage = .completion
            case .completion: break
            }
        }
    }
    
    func moveToPrevious() {
        direction = .backward
        withAnimation(.easeInOut) {
            switch currentPage {
            case .splash: break
            case .welcome: currentPage = .splash
            case .personalInfo: currentPage = .welcome
            case .playerStyle: currentPage = .personalInfo
            case .strengths: currentPage = .playerStyle
            case .weaknesses: currentPage = .strengths
            case .teamStatus: currentPage = .weaknesses
            case .goals: currentPage = .teamStatus
            case .timeline: currentPage = .goals
            case .trainingPreferences: currentPage = .timeline
            case .completion: currentPage = .trainingPreferences
            }
        }
    }
}
