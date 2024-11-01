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
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var currentQuestionnaireTwo: Int
    // selected yesno
    @Binding var selectedYesNoTeam: String
    // stored in string
    @Binding var chosenYesNoTeam: [String]
    
    let yesNoTeam = ["Yes I am currently on a team", "No I am not currently on a team"]
    
    var body: some View {
        VStack (spacing: 25) {
            // lazy for better performance
            LazyVStack (spacing: 10) {
                ForEach(yesNoTeam, id: \.self) { yesNo in
                    Button(action: {
                        toggleYesNoSelection(yesNo)
                    }) {
                        HStack {
                            Text(yesNo)
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenYesNoTeam.contains(yesNo) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        .background(chosenYesNoTeam.contains(yesNo) ? globalSettings.primaryYellowColor : Color.clear)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1) // Customize border color and width
                        )
                    }
                }
            }
            // LazyVStack padding
            .padding(.horizontal)
        }
        // VStack padding
        .padding(.horizontal)
    }
    private func toggleYesNoSelection(_ yesNo: String) {
        if chosenYesNoTeam.contains(yesNo) {
            // If the player is already selected, remove them. Prevents from multiple selections of one player
            chosenYesNoTeam.removeAll { $0 == yesNo }
        } else if chosenYesNoTeam.count < 1 { // indices
            // If yes or no is selected, add it
            chosenYesNoTeam.append(yesNo)
        }
    }
}
