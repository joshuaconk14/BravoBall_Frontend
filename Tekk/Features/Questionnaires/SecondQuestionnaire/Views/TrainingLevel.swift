//
//  TrainingLevel.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//

import Foundation
import SwiftUI

struct TrainingLevel: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedLevel: String
    @Binding var chosenLevel: [String]
    
    let levels = ["Light (2-3 sessions/week)",
                  "Moderate (3-4 sessions/week)",
                  "Intense (4-5 sessions/week)",
                  "Professional (6+ sessions/week)"]
    
    var body: some View {
        VStack {
            Text("What training intensity level suits you best?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: levels,
                maxSelections: 1,
                selectedItems: $chosenLevel
            ) { level in
                level
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct TrainingLevel_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        
        TrainingLevel(
            selectedLevel: .constant(""),
            chosenLevel: .constant([])
        )
        .environmentObject(stateManager)
        .environmentObject(coordinator)
    }
}

