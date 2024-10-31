//
//  PickStrengths.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is for letting the player choose their strengths from the question "What are your biggest strengths?"

import SwiftUI
import Foundation

// MARK: - Questionnaire 2
struct Questionnaire_2: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var currentQuestionnaire: Int
    @Binding var selectedStrength: String
    @Binding var chosenStrengths: [String] // Change to Binding
    
    //LazyVStack options for players
    let strengths = ["Passing", "Dribbling", "Shooting", "First Touch", "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        VStack (spacing: 25) {
            // LazyVStack used for memory usage, since this will be a large list
            LazyVStack (spacing: 10) {
                ForEach(strengths, id: \.self) { strength in
                    Button(action: {
                        toggleStrengthSelection(strength)
                    }) {
                        HStack {
                            Text(strength)
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenStrengths.contains(strength) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        .background(chosenStrengths.contains(strength) ? globalSettings.primaryYellowColor : Color.clear)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1) // Customize border color and width
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private func toggleStrengthSelection(_ strength: String) {
        if chosenStrengths.contains(strength) {
            // If the player is already selected, remove them. Prevents from multiple selections of one player
            chosenStrengths.removeAll { $0 == strength }
        } else if chosenStrengths.count < 3 { // count max = 2 because they're indices
            // If the player is not selected and we have less than 3, add them
            chosenStrengths.append(strength)
        }
    }
}
