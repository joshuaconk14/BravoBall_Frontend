//
//  PickStrengths.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is for letting the player choose their strengths from the question "What are your biggest strengths?"

import SwiftUI
import Foundation

struct PickStrengths: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedStrength: String
    @Binding var chosenStrengths: [String]
    
    let strengths = ["Passing", "Dribbling", "Shooting", "First Touch",
                     "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        VStack {
            Text("What are your biggest strengths?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: strengths,
                maxSelections: 3,
                selectedItems: $chosenStrengths
            ) { strength in
                strength
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct PickStrengths_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        
        PickStrengths(
            selectedStrength: .constant(""),
            chosenStrengths: .constant([])
        )
        .environmentObject(stateManager)
        .environmentObject(coordinator)
    }
}
