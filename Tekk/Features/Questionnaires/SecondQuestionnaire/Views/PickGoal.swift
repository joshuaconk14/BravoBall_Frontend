//
//  PickGoal.swift
//  BravoBall
//
//  Created by Jordan on 10/31/24.
//

import SwiftUI

struct PickGoal: View {
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
    @State static var currentQuestionnaireTwo = 1
    @State static var selectedGoal = ""
    @State static var chosenGoal: [String] = []
    
    static var previews: some View {
        PickGoal(
            currentQuestionnaireTwo: $currentQuestionnaireTwo,
            selectedGoal: $selectedGoal,
            chosenGoal: $chosenGoal
        )
    }
}
