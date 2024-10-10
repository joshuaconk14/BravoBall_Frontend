//
//  QuestionsTwo.swift
//  Tekk
//
//  Created by Joshua Conklin on 10/8/24.
//
import SwiftUI
import RiveRuntime

struct QuestionnaireTwo_1: View {
    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedYesNoTeam: String
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
                                .foregroundColor(.white)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenYesNoTeam.contains(yesNo) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                            }
                        }
                        .background(chosenYesNoTeam.contains(yesNo) ? Color(hex: "5fa552") : Color.clear)
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
