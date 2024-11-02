//
//  TimelineGoal.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct TimelineGoal: View {
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
    @State static var currentQuestionnaireTwo = 2
    @State static var selectedTimeline = ""
    @State static var chosenTimeline: [String] = []
    
    static var previews: some View {
        TimelineGoal(
            currentQuestionnaireTwo: $currentQuestionnaireTwo,
            selectedTimeline: $selectedTimeline,
            chosenTimeline: $chosenTimeline
        )
    }
}

