//
//  TrainingDays.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

struct TrainingDays: View {
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
    @State static var currentQuestionnaireTwo = 4
    @State static var selectedDays = ""
    @State static var chosenDays: [String] = []
    
    static var previews: some View {
        TrainingDays(
            currentQuestionnaireTwo: $currentQuestionnaireTwo,
            selectedDays: $selectedDays,
            chosenDays: $chosenDays
        )
        .previewLayout(.sizeThatFits)
    }
}

