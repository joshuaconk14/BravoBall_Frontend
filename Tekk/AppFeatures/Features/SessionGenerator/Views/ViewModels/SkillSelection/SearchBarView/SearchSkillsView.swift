//
//  SearchSkillsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import SwiftUI

struct SearchSkillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(filteredSkills, id: \.self) { skill in
                    VStack(alignment: .leading) {
                        SkillRow(
                            appModel: appModel,
                            sessionModel: sessionModel,
                            skill: skill
                        )
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            if sessionModel.selectedSkills.count > 0 {
                Button(action: {
                    searchText = ""
                    appModel.viewState.showSkillSearch = false
                }) {
                    Text("Create Session")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .padding()
            }
            
        }
    }
    
    // Flatten all skills for searching
    private var allSkills: [String] {
        SessionGeneratorView.skillCategories.flatMap { category in
            category.subSkills.map { subSkill in
                (subSkill)
            }
        }
        
    }

    private var filteredSkills: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return allSkills.filter { skill in
                skill.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
