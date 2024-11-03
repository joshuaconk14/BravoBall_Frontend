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

    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedYesNoTeam: String
    @Binding var chosenYesNoTeam: [String]
    
    let yesNoTeam = ["Yes I am currently on a team",
                     "No I am not currently on a team"]
    
    var body: some View {
        SelectionListView(
            items: yesNoTeam,
            maxSelections: 1,
            selectedItems: $chosenYesNoTeam
        ) { option in
            option
        }
    }
}

struct YesNoTeam_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        YesNoTeam(
            currentQuestionnaireTwo: .constant(1),
            selectedYesNoTeam: .constant(""),
            chosenYesNoTeam: .constant([])
        )
        .environmentObject(stateManager)
    }
}
