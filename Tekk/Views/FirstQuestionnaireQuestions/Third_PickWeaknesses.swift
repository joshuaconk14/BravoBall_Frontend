//
//  PickWeaknesses.swift
//  BravoBall
//
//  Created by Jordan on 10/30/24.
//
// This file is for letting the player choose their weaknesses from the question "What are your biggest weaknesses?"

import SwiftUI
import Foundation

// MARK: - Questionnaire 3
struct Questionnaire_3: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var currentQuestionnaire: Int
    @Binding var selectedWeakness: String
    @Binding var chosenWeaknesses: [String] // Change to Binding
    
    //LazyVStack options for players
    let weaknesses = ["Passing", "Dribbling", "Shooting", "First Touch", "Crossing", "1v1 Defending", "1v1 Attacking", "Vision"]
    
    var body: some View {
        VStack (spacing: 25) {
            // LazyVStack used for memory usage, since this will be a large list
            LazyVStack (spacing: 10) {
                ForEach(weaknesses, id: \.self) { weakness in
                    Button(action: {
                        toggleWeaknessSelection(weakness)
                    }) {
                        HStack {
                            Text(weakness)
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenWeaknesses.contains(weakness) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        .background(chosenWeaknesses.contains(weakness) ? globalSettings.primaryYellowColor : Color.clear)
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
    
    private func toggleWeaknessSelection(_ weakness: String) {
        if chosenWeaknesses.contains(weakness) {
            // If the player is already selected, remove them. Prevents from multiple selections of one player
            chosenWeaknesses.removeAll { $0 == weakness }
        } else if chosenWeaknesses.count < 3 { // count max = 2 because they're indices
            // If the player is not selected and we have less than 3, add them
            chosenWeaknesses.append(weakness)
        }
    }
}
