//
//  AvailableEquipment.swift
//  BravoBall
//
//  Created by Jordan on 12/30/24.
//

import SwiftUI
import Foundation

struct AvailableEquipment: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedEquipment: String
    @Binding var chosenEquipment: [String]
    
    let equipment = [
            "Ball",
            "Cones",
            "Field with Goals",
            "Agility Ladder",
            "Passing Wall"
        ]
    
    var body: some View {
            SelectionListView(
                items: equipment,
                maxSelections: equipment.count, // Allow selecting all equipment
                selectedItems: $chosenEquipment
            ) { item in
                item
            }
        }
}

// MARK: - Preview
struct AvailableEquipment_Previews: PreviewProvider {
    static var previews: some View {
        let stateManager = OnboardingStateManager()
        AvailableEquipment(
            currentQuestionnaireTwo: .constant(6),
            selectedEquipment: .constant(""),
            chosenEquipment: .constant([])
        )
        .environmentObject(stateManager)
    }
}
