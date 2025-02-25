//
//  SkillRow.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import SwiftUI

struct SkillRow: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let skill: String
    
    var body: some View {
        Button( action: {
            if sessionModel.selectedSkills.contains(skill) {
                sessionModel.selectedSkills.remove(skill)
            } else {
                sessionModel.selectedSkills.insert(skill)
            }
        }) {
            HStack {
                Image(systemName: "figure.soccer")
                    .font(.system(size: 24))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(skill)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(.black)
                    Text("Defending")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
    }
    
}
