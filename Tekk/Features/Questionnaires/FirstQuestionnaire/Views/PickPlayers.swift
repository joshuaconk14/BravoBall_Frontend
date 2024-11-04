//
//  PickPlayers.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI
import Foundation

struct PickPlayers: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    @Binding var selectedPlayer: String
    @Binding var chosenPlayers: [String]
    
    let players = [
        "Lionel Messi",
        "Cristiano Ronaldo",
        "Kylian Mbappe",
        "Erling Haaland",
        "Kevin De Bruyne",
        "Jude Bellingham",
        "Vinicius Jr",
        "Mohamed Salah"
    ]
    
    var body: some View {
        VStack {
            Text("Which player represents your playstyle the best?")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .padding(.bottom, 20)
            
            SelectionListView(
                items: players,
                maxSelections: 1,
                selectedItems: $chosenPlayers
            ) { player in
                player
            }
        }
        .transition(.move(edge: questionnaireCoordinator.direction == .forward ? .trailing : .leading))
        .animation(.easeInOut, value: questionnaireCoordinator.currentStep)
    }
}

// MARK: - Preview
struct PickPlayers_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        let coordinator = QuestionnaireCoordinator()
        
        PickPlayers(
            selectedPlayer: .constant(""),
            chosenPlayers: .constant([])
        )
        .environmentObject(stateManager)
        .environmentObject(coordinator)
    }
}
