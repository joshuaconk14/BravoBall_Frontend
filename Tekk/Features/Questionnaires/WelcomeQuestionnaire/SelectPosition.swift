//
//  SelectPosition.swift
//  BravoBall
//
//  Created by Jordan on 11/7/24.
//

import Foundation
import SwiftUI

struct SelectPosition: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var currentWelcomeStage: Int
    @Binding var selectedPosition: String
    @Binding var chosenPosition: [String]
    
    let positionOptions = [
        "Goalkeeper",
        "Fullback",
        "Centerback",
        "Defensive Mid",
        "Central Mid",
        "Attacking Mid",
        "Winger",
        "Forward"
    ]
    
    var body: some View {
        SelectionListView(
            items: positionOptions,
            maxSelections: 1,
            selectedItems: $chosenPosition
        ) { position in
            position
        }
    }
}   
