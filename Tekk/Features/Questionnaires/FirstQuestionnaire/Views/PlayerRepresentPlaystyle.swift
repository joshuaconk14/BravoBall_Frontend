//
//  PlayerRepresentPlaystyle.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is for showing the players and selecting them in the question "Which player do you feel represents your playstyle the best?"

import SwiftUI
import Foundation

struct PlayerRepresentPlaystyle: View {
    @Binding var currentQuestionnaire: Int
    @Binding var selectedPlayer: String
    @Binding var chosenPlayers: [String]
    
    let players = ["Alan Virginius", "Harry Maguire", "Big Bjorn", "Big Adam",
                   "Big Bulk", "Oscar Bobb", "Gary Gardner", "The Enforcer"]
    
    var body: some View {
        SelectionListView(
            items: players,
            maxSelections: 3,
            selectedItems: $chosenPlayers
        ) { player in
            player
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
