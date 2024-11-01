//
//  PickGoal.swift
//  BravoBall
//
//  Created by Jordan on 10/31/24.
//

import Foundation

struct PickGoal: View {
    @Binding var currentQuestionnaireTwo: Int
    // selected goal
    @Binding var selectedGoal: String
    // stored in string
    @Binding var chosenGoal: [String]


    let goals = ["I want to improve my overall skill level", "I want to be the best player on my team", "I want to get scouted for college", "I want to become a professional soccer player."]

    var body: some View {

    }
}
