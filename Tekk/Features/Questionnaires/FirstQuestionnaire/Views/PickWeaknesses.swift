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
    @Binding var currentQuestionnaire: Int
    @Binding var selectedWeakness: String
    @Binding var chosenWeaknesses: [String]
    
    let weaknesses = ["Passing", "Dribbling", "Shooting", "First Touch",
                      "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        SelectionListView(
            items: weaknesses,
            maxSelections: 3,
            selectedItems: $chosenWeaknesses
        ) { weakness in
            weakness
        }
    }
}

// MARK: - Preview for PickWeaknesses
struct PickWeaknesses_Previews: PreviewProvider {
    @State static var currentQuestionnaire = 3
    @State static var selectedWeakness = ""
    @State static var chosenWeaknesses: [String] = []
    
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        PickWeaknesses(
            currentQuestionnaire: $currentQuestionnaire,
            selectedWeakness: $selectedWeakness,
            chosenWeaknesses: $chosenWeaknesses
        )
        .environmentObject(stateManager)
    }
}
