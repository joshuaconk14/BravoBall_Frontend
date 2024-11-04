//
//  PickWeaknesses.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is for letting the player choose their weaknesses from the question "What are your biggest weaknesses?"

import SwiftUI
import Foundation

struct PickWeaknesses: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedWeakness: String
    @Binding var chosenWeaknesses: [String]
    
    let weaknesses = ["Passing", "Dribbling", "Shooting", "First Touch",
                      "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        VStack {
            Text("What areas would you like to improve?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: weaknesses,
                maxSelections: 3,
                selectedItems: $chosenWeaknesses
            ) { weakness in
                weakness
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct PickWeaknesses_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        
        PickWeaknesses(
            selectedWeakness: .constant(""),
            chosenWeaknesses: .constant([])
        )
        .environmentObject(stateManager)
        .environmentObject(coordinator)
    }
}
