//
//  SelectLevel.swift
//  BravoBall
//
//  Created by Jordan on 11/7/24.
//

import Foundation
import SwiftUI

struct SelectLevel: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var currentWelcomeStage: Int
    @Binding var selectedLevel: String
    @Binding var chosenLevel: [String]
    
    let levelOptions = [
        "Beginner",
        "Intermediate",
        "Competitive",
        "Professional"
    ]
    
    var body: some View {
        SelectionListView(
            items: levelOptions,
            maxSelections: 1,
            selectedItems: $chosenLevel
        ) { level in
            level
        }
    }
}
