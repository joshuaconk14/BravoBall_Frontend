//
//  SecondQuestionnaireQuestions.swift
//  BravoBall
//
//  Created by Joshua Conklin on 10/8/24.
//
// This file is for displaying the questions in the second questionnaire for the user

import SwiftUI
import RiveRuntime

struct YesNoTeam: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedYesNoTeam: String
    @Binding var chosenYesNoTeam: [String]
    
    let yesNoTeam = ["Yes I am currently on a team",
                     "No I am not currently on a team"]
    
    var body: some View {
        VStack {
            Text("Are you currently on a team?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: yesNoTeam,
                maxSelections: 1,
                selectedItems: $chosenYesNoTeam
            ) { option in
                option
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

struct YesNoTeam_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        YesNoTeam(
            selectedYesNoTeam: .constant(""),
            chosenYesNoTeam: .constant([])
        )
        .environmentObject(stateManager)
    }
}
