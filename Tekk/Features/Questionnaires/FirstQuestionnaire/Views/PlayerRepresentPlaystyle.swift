//
//  PlayerRepresentPlaystyle.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is for showing the players and selecting them in the question "Which player do you feel represents your playstyle the best?"

import SwiftUI
import Foundation

// MARK: - Questionnaire 1
struct PlayerRepresentPlaystyle: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var currentQuestionnaire: Int
    @Binding var selectedPlayer: String
    @Binding var chosenPlayers: [String]
    
    //LazyVStack options for players
    let players = ["Alan Virginius", "Harry Maguire", "Big Bjorn", "Big Adam", "Big Bulk", "Oscar Bobb", "Gary Gardner", "The Enforcer"]
    
    var body: some View {
        VStack (spacing: 25) {
            // LazyVStack used for memory usage, since this will be a large list
            LazyVStack (spacing: 10) {
                ForEach(players, id: \.self) { player in
                    Button(action: {
                        togglePlayerSelection(player)
                    }) {
                        HStack {
                            Text(player)
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenPlayers.contains(player) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        .background(chosenPlayers.contains(player) ? globalSettings.primaryYellowColor : Color.clear)
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
    
    private func togglePlayerSelection(_ player: String) {
        if chosenPlayers.contains(player) {
            // If the player is already selected, remove them. Prevents from multiple selections of one player
            chosenPlayers.removeAll { $0 == player }
        } else if chosenPlayers.count < 3 { // indices
            // If the player is not selected and we have less than 3, add them
            chosenPlayers.append(player)
        }
    }
}

// MARK: - Preview for PlayerRepresentPlaystyle
struct PlayerRepresentPlaystyle_Previews: PreviewProvider {
    @State static var currentQuestionnaire = 1
    @State static var selectedPlayer = ""
    @State static var chosenPlayers: [String] = []
    
    static var previews: some View {
        PlayerRepresentPlaystyle(
            currentQuestionnaire: $currentQuestionnaire,
            selectedPlayer: $selectedPlayer,
            chosenPlayers: $chosenPlayers
        )
    }
}
