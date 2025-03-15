//
//  SpecificDrillsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//
import SwiftUI

struct SpecificDrillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let type: String
    let dismiss: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Back")
                                .font(.custom("Poppins-Bold", size: 16))
                        }
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .padding()
                    }
                    
                    Text(appModel.selectedTrainingStyle != nil ? ("\(type) Intensity") : type)
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding(.leading, 70)
                    
                    
                    Spacer()
                }
                
                // Drills list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(specificDrills) { drill in
                            DrillRow(appModel: appModel, sessionModel: sessionModel,
                                     drill: drill
                            )
                            .padding(.horizontal)
                            Divider()
                        }
                    }
                }
            }
        }
        .background(Color.white)
    }
    
    // Returning drills based on type selected
    var specificDrills: [DrillModel] {
        if appModel.selectedSkillButton != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.skill.lowercased().contains(type.lowercased())
            }
        } else if appModel.selectedTrainingStyle != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.trainingStyle.lowercased().contains(type.lowercased())
            }
        }
        if appModel.selectedDifficulty != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.difficulty.lowercased().contains(type.lowercased())
            }
        } else {
            return []
        }
    }
}
