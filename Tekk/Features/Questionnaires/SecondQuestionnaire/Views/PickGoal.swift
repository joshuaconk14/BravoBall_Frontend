//
//  PickGoal.swift
//  BravoBall
//
//  Created by Jordan on 10/31/24.
//

import SwiftUI

struct PickGoal: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedGoal: String
    @Binding var chosenGoal: [String]
    
    let goals = ["I want to improve my overall skill level",
                 "I want to be the best player on my team",
                 "I want to get scouted for college",
                 "I want to become a professional soccer player."]
    
    var body: some View {
        VStack {
            Text("What is your main goal?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: goals,
                maxSelections: 1,
                selectedItems: $chosenGoal
            ) { goal in
                goal
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct PickGoal_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        PickGoal(
            selectedGoal: .constant(""),
            chosenGoal: .constant([])
        )
        .environmentObject(stateManager)
    }
}
