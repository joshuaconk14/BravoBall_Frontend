//
//  DrillResultsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/15/25.
//

import SwiftUI

struct DrillResultsView: View {
    @ObservedObject var mainAppModel: MainAppModel
    @Environment(\.presentationMode) var presentationMode
    
    
    
    var body: some View {
        VStack {
            HStack {
                backButton
                Spacer()
            }
            .padding()
            
            Text("Results:")
            
            Spacer ()
            
            if let session = mainAppModel.selectedSession {
                Text("Drill date: \(formatDate(session.date))")
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
    
    private var backButton: some View {
        Button(action: {
            mainAppModel.showDrillShower = false
            mainAppModel.selectedSession = nil
        }) {
            HStack {
                Image(systemName: "xmark")
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
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
                equipment: ["Ball", "Cones"]
            )
        ]
    
    // Create mock session
        mockMainAppModel.selectedSession = MainAppModel.CompletedSession(
            date: Date(),
            drills: mockDrills
        )
    
    return DrillResultsView(mainAppModel: mockMainAppModel)
}
