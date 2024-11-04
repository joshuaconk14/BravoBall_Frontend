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
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedTimeline: String
    @Binding var chosenTimeline: [String]
    
    let timelines = ["1-3 months",
                     "3-6 months",
                     "6-12 months",
                     "12+ months"]
    
    var body: some View {
        VStack {
            Text("What's your timeline for achieving this goal?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: timelines,
                maxSelections: 1,
                selectedItems: $chosenTimeline
            ) { timeline in
                timeline
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct TimelineGoal_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        TimelineGoal(
            selectedTimeline: .constant(""),
            chosenTimeline: .constant([])
        )
        .environmentObject(stateManager)
    }
}
