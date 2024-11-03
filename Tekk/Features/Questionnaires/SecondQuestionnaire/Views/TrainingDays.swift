//
//  TrainingDays.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

struct TrainingDays: View {
    @EnvironmentObject var stateManager: OnboardingStateManager

    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedDays: String
    @Binding var chosenDays: [String]
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        SelectionListView(
            items: days,
            maxSelections: 7,
            selectedItems: $chosenDays
        ) { day in
            day // Simple string conversion
        }
    }
}

// MARK: - Preview
struct TrainingDays_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        TrainingDays(
            currentQuestionnaireTwo: .constant(5),
            selectedDays: .constant(""),
            chosenDays: .constant([])
        )
        .environmentObject(stateManager)
    }
}
