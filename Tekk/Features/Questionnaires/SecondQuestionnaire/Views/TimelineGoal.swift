//
//  TimelineGoal.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

struct TimelineGoal: View {
    @EnvironmentObject var stateManager: OnboardingStateManager

    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedTimeline: String
    @Binding var chosenTimeline: [String]
    
    let timelines = ["Within 3 months",
                     "Within 6 months",
                     "Within 1 year",
                     "Long term goal (2+ years)"]
    
    var body: some View {
        SelectionListView(
            items: timelines,
            maxSelections: 1,
            selectedItems: $chosenTimeline
        ) { timeline in
            timeline
        }
    }
}

// MARK: - Preview
struct TimelineGoal_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        TimelineGoal(
            currentQuestionnaireTwo: .constant(3),
            selectedTimeline: .constant(""),
            chosenTimeline: .constant([])
        )
        .environmentObject(stateManager)
    }
}
