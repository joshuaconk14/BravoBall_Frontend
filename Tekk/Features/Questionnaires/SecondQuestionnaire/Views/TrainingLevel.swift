//
//  TrainingLevel.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct TrainingLevel: View {
    @EnvironmentObject var stateManager: OnboardingStateManager

    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedLevel: String
    @Binding var chosenLevel: [String]
    
    let levels = ["Light (2-3 sessions/week)",
                  "Moderate (3-4 sessions/week)",
                  "Intense (4-5 sessions/week)",
                  "Professional (6+ sessions/week)"]
    
    var body: some View {
        SelectionListView(
            items: levels,
            maxSelections: 1,
            selectedItems: $chosenLevel
        ) { level in
            level
        }
    }
}


// MARK: - Preview
struct TrainingLevel_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        TrainingLevel(
            currentQuestionnaireTwo: .constant(4),
            selectedLevel: .constant(""),
            chosenLevel: .constant([])
        )
        .environmentObject(stateManager)
    }
}

