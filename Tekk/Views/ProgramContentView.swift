//
//  ProgramContentView.swift
//  BravoBall
//
//  Created by Jordan on 11/12/24.
//

import Foundation
import SwiftUI

struct ProgramContentView: View {
    let program: Program
    @State private var selectedWeek = 1
    @State private var showWeekSelector = false
    @StateObject private var globalSettings = GlobalSettings()
    
    var currentWeek: Week? {
        program.weeks.first { $0.weekNumber == selectedWeek }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Week selector button
            Button(action: { showWeekSelector.toggle() }) {
                HStack {
                    Text("Week \(selectedWeek)")
                        .font(.custom("Poppins-Bold", size: 18))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(globalSettings.primaryDarkColor)
                }
                .padding()
                .background(Color.white)
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Week info
                    if let week = currentWeek {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(week.theme)
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(globalSettings.primaryDarkColor)
                            
                            Text(week.description)
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(.gray)
                        }
                        .padding()
                        
                        // Drills
                        ForEach(week.drills) { drill in
                            DrillCardView(drill: drill)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            
            // Week selector overlay
            if showWeekSelector {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showWeekSelector = false
                    }
                
                VStack {
                    ForEach(program.weeks) { week in
                        Button(action: {
                            selectedWeek = week.weekNumber
                            showWeekSelector = false
                        }) {
                            Text("Week \(week.weekNumber)")
                                .font(.custom("Poppins-Regular", size: 16))
                                .foregroundColor(selectedWeek == week.weekNumber ? globalSettings.primaryYellowColor : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedWeek == week.weekNumber ? Color.yellow.opacity(0.1) : Color.clear)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(15)
                .padding()
            }
        }
    }
}

// Preview provider
struct ProgramContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProgram = Program(
            weeks: [
                Week(
                    weekNumber: 1,
                    theme: "Building Scoring Ability",
                    description: "Focus on improving heading and weak foot skills",
                    drills: [
                        Drill(
                            title: "Heading Drill",
                            description: "Practice heading with proper technique",
                            duration: 20,
                            type: "Technical",
                            difficulty: "Intermediate",
                            equipment: ["Cones", "Goalkeeper"],
                            instructions: ["Set up cones", "Practice headers"],
                            tips: ["Keep eyes on ball"],
                            videoUrl: nil
                        )
                    ]
                )
            ],
            difficulty: "Intermediate",
            focusAreas: ["Technical", "Game Situational"]
        )
        
        ProgramContentView(program: sampleProgram)
    }
}
