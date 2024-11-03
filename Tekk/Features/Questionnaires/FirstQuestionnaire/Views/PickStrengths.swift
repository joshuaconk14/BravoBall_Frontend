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
    @Binding var currentQuestionnaire: Int
    @Binding var selectedStrength: String
    @Binding var chosenStrengths: [String]
    
    let strengths = ["Passing", "Dribbling", "Shooting", "First Touch",
                     "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        SelectionListView(
            items: strengths,
            maxSelections: 3,
            selectedItems: $chosenStrengths
        ) { strength in
            strength
        }
    }
}

// MARK: - Preview for PickStrengths
struct PickStrengths_Previews: PreviewProvider {
    @State static var currentQuestionnaire = 2
    @State static var selectedStrength = ""
    @State static var chosenStrengths: [String] = []
    
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        PickStrengths(
            currentQuestionnaire: $currentQuestionnaire,
            selectedStrength: $selectedStrength,
            chosenStrengths: $chosenStrengths
        )
        .environmentObject(stateManager)
    }
}
