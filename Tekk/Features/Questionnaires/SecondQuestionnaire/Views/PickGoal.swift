//
//  PickGoal.swift
//  BravoBall
//
//  Created by Jordan on 10/31/24.
//

import SwiftUI

struct PickGoal: View {
    @EnvironmentObject var stateManager: OnboardingStateManager

    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedGoal: String
    @Binding var chosenGoal: [String]
    
    let goals = ["I want to improve my overall skill level",
                 "I want to be the best player on my team",
                 "I want to get scouted for college",
                 "I want to become a professional soccer player."]
    
    var body: some View {
        SelectionListView(
            items: goals,
            maxSelections: 1,
            selectedItems: $chosenGoal
        ) { goal in
            goal
        }
    }
}

// MARK: - Preview
struct PickGoal_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        PickGoal(
            currentQuestionnaireTwo: .constant(2),
            selectedGoal: .constant(""),
            chosenGoal: .constant([])
        )
        .environmentObject(stateManager)
    }
}
