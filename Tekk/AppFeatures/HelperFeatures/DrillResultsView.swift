//
//  DrillResultsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/15/25.
//

import SwiftUI

struct DrillResultsView: View {
    @ObservedObject var appModel: MainAppModel
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    backButton
                    Spacer()
                }
                .padding()
                
                Spacer ()
                
                if let session = appModel.selectedSession {
                    Text("Drill date: \(formatDate(session.date))")
                        .padding()
                    Text("Score: \(session.totalCompletedDrills) / \(session.totalDrills)")
                        .padding()
                        ForEach(session.drills, id: \.name) { drill in
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Drill: \(drill.name)")
                                    .font(.custom("Poppins-Bold", size: 16))
                                Text("Skill: \(drill.skill)")
                                    .font(.custom("Poppins-Regular", size: 14))
                                HStack(spacing: 20) {
                                    Text("Duration: \(drill.duration)min")
                                    Text("Sets: \(drill.sets)")
                                    Text("Reps: \(drill.reps)")
                                }
                                .font(.custom("Poppins-Regular", size: 14))
                                Text("Equipment: \(drill.equipment.joined(separator: ", "))")
                                    .font(.custom("Poppins-Regular", size: 14))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        .padding()
                }
                
                Spacer()
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            appModel.showDrillResults = false
            appModel.selectedSession = nil
        }) {
            HStack {
                Image(systemName: "xmark")
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
            }
        }
    }
    
    // testing
    private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
}

#Preview {
    let mockMainAppModel = MainAppModel()
    
    // Create mock drill data
        let mockDrills = [
            MainAppModel.DrillData(
                name: "Speed Dribbling",
                skill: "Ball Control",
                duration: 20,
                sets: 4,
                reps: 10,
                equipment: ["Ball", "Cones"],
                isCompleted: true
            )
        ]
    
    // Create mock session
        mockMainAppModel.selectedSession = MainAppModel.CompletedSession(
            date: Date(),
            drills: mockDrills,
            totalCompletedDrills: 3,
            totalDrills: 4
        )
    
    return DrillResultsView(appModel: mockMainAppModel)
}
