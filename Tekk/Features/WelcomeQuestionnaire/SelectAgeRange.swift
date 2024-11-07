//
//  SelectAgeRange.swift
//  BravoBall
//
//  Created by Jordan on 11/7/24.
//

import Foundation
import SwiftUI

struct SelectAgeRange: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var currentWelcomeStage: Int
    @Binding var selectedAge: String
    @Binding var chosenAge: [String]
    
    let ageOptions = [
        "Youth (Under 12)",
        "Teen (13-16)",
        "Junior (17-19)",
        "Adult (20-29)",
        "Senior (30+)"
    ]
    
    var body: some View {
        SelectionListView(
            items: ageOptions,
            maxSelections: 1,
            selectedItems: $chosenAge
        ) { age in
            age
        }
    }
}
