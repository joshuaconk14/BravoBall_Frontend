///
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
                            ZStack {
                                RiveViewModel(fileName: "Paw_Yellow").view()
                                    .frame(width: 40, height: 40)
                                Text(text)
                                    .font(.custom("Poppins-Bold", size: 22))
                                    .foregroundColor(Color.white)
                            }
                        } else {
                            ZStack {
                                RiveViewModel(fileName: "Paw_Gray").view()
                                    .frame(width: 40, height: 40)
                                Text(text)
                                    .font(.custom("Poppins-Bold", size: 22))
                                    .foregroundColor(Color.white)
                            }
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
                        .font(.custom("Poppins-Bold", size: 22))
                        .foregroundColor(Color.white)
                        .background(
                            Circle()
                                .fill(Color.blue)
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
    
    // Create mock drills using EditableDrillModel
    let mockDrills = [
        EditableDrillModel(
            drill: DrillModel(
                title: "Test Drill 1",
                skill: "Dribbling",
                sets: 4,
                reps: 8,
                duration: 20,
                description: "A basic dribbling drill to improve ball control",
                tips: ["Keep the ball close", "Use both feet"],
                equipment: ["Ball"],
                trainingStyle: "Medium Intensity",
                difficulty: "Beginner"
            ),
            sets: 4,
            reps: 8,
            duration: 20,
            isCompleted: true
        ),
        EditableDrillModel(
            drill: DrillModel(
                title: "Test Drill 2",
                skill: "Shooting",
                sets: 3,
                reps: 10,
                duration: 15,
                description: "Practice shooting accuracy and power",
                tips: ["Follow through", "Plant foot beside ball"],
                equipment: ["Ball", "Goal"],
                trainingStyle: "High Intensity",
                difficulty: "Intermediate"
            ),
            sets: 3,
            reps: 10,
            duration: 15,
            isCompleted: true
        )
    ]
    
    // Create mock session with EditableDrillModel array
    let mockSession = MainAppModel.CompletedSession(
        date: Date(),
        drills: mockDrills,
        totalCompletedDrills: 2,
        totalDrills: 2
    )
    
    return WeekDisplayButton(
        appModel: mockAppModel,
        text: "34",
        date: Date(),
        highlightedDay: false,
        session: mockSession
    )
}
