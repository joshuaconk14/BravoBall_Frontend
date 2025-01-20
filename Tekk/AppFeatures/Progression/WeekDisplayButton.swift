//
//  WeekDisplayButton.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/12/25.
//

import SwiftUI
import RiveRuntime


struct WeekDisplayButton: View {
    @ObservedObject var appModel: MainAppModel
    
    let text: String
    let date: Date
    let highlightedDay: Bool
    let session: MainAppModel.CompletedSession?
    
    var body: some View {
        
        ZStack {
        
            if let session = session {
                
                // Convert to float types, get score
                let score = Double(session.totalCompletedDrills) / Double(session.totalDrills)
                
                Button(action: {
                        // Lets DrillResultsView access session
                        appModel.selectedSession = session
                        appModel.showDrillResults = true
                }) {
                    ZStack {
                        RiveViewModel(fileName: "Day_Null").view()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                        
                        if score == 1.0 {
                            Text(text)
                                .font(.custom("Poppins-Bold", size: 25))
                                .foregroundColor(Color.white)
                                .background(
                                    Circle()
                                        .fill(appModel.globalSettings.primaryYellowColor)
                                        .frame(width: 38, height: 38)
                                )
                        } else {
                            Text(text)
                                .font(.custom("Poppins-Bold", size: 25))
                                .foregroundColor(Color.white)
                                .background(
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 38, height: 38)
                                )
                        }
                    }
                }
                
            } else {
                RiveViewModel(fileName: "Day_Null").view()
                    .frame(width: 60, height: 60)
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                
                if highlightedDay {
                    Text(text)
                        .font(.custom("Poppins-Bold", size: 25))
                        .foregroundColor(Color.white)
                        .background(
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 38, height: 38)
                        )
                } else {
                    Text(text)
                        .font(.custom("Poppins-Bold", size: 25))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
            }
        }
    }
}


#Preview {
    let mockAppModel = MainAppModel()
    
    // Create mock drills
        let mockDrills = [
            MainAppModel.DrillData(
                name: "Test Drill 1",
                skill: "Dribbling",
                duration: 20,
                sets: 4,
                reps: 8,
                equipment: ["Ball"],
                isCompleted: true
            ),
            MainAppModel.DrillData(
                name: "Test Drill 2",
                skill: "Shooting",
                duration: 15,
                sets: 3,
                reps: 10,
                equipment: ["Ball", "Goal"],
                isCompleted: true
            )
        ]
        
        // Create mock session
        let mockSession = MainAppModel.CompletedSession(
            date: Date(),
            drills: mockDrills,
            totalCompletedDrills: 2,  // One drill completed
            totalDrills: 2           // Out of two total drills
        )
    
    return WeekDisplayButton(
        appModel: mockAppModel,
        text: "34",
        date: Date(),
        highlightedDay: false,
        session: mockSession
    )
}
