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
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedDays: String
    @Binding var chosenDays: [String]
    
    let days = ["Monday", "Tuesday", "Wednesday", "Thursday",
                "Friday", "Saturday", "Sunday"]
    
    var body: some View {
        VStack {
            Text("Which days would you like to train?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: days,
                maxSelections: 7,
                selectedItems: $chosenDays
            ) { day in
                day
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct TrainingDays_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        
        TrainingDays(
            selectedDays: .constant(""),
            chosenDays: .constant([])
        )
        .environmentObject(stateManager)
        .environmentObject(coordinator)
    }
}
