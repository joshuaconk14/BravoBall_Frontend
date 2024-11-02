//
//  PickGoal.swift
//  BravoBall
//
//  Created by Jordan on 10/31/24.
//

import SwiftUI

struct PickGoal: View {
    @StateObject private var globalSettings = GlobalSettings()
    
    @Binding var currentQuestionnaireTwo: Int
    @Binding var selectedGoal: String
    @Binding var chosenGoal: [String]
    
    let goals = ["I want to improve my overall skill level", 
                 "I want to be the best player on my team", 
                 "I want to get scouted for college", 
                 "I want to become a professional soccer player."]
    
    var body: some View {
        VStack(spacing: 25) {
            LazyVStack(spacing: 10) {
                ForEach(goals, id: \.self) { goal in
                    Button(action: {
                        toggleGoalSelection(goal)
                    }) {
                        HStack {
                            Text(goal)
                                .foregroundColor(globalSettings.primaryDarkColor)
                                .padding()
                                .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                            if chosenGoal.contains(goal) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        .background(chosenGoal.contains(goal) ? globalSettings.primaryYellowColor : Color.clear)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
    }
    
    private func toggleGoalSelection(_ goal: String) {
        if chosenGoal.contains(goal) {
            chosenGoal.removeAll { $0 == goal }
        } else if chosenGoal.count < 1 {  // Only allow one selection
            chosenGoal.append(goal)
        }
    }
}

// MARK: - Preview
struct PickGoal_Previews: PreviewProvider {
    @State static var currentQuestionnaireTwo = 1
    @State static var selectedGoal = ""
    @State static var chosenGoal: [String] = []
    
    static var previews: some View {
        PickGoal(
            currentQuestionnaireTwo: $currentQuestionnaireTwo,
            selectedGoal: $selectedGoal,
            chosenGoal: $chosenGoal
        )
    }
}
