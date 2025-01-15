//
//  DrillDetailView.swift
//  BravoBall
//
//  Created by Jordan on 1/12/25.
//


import SwiftUI

struct DrillDetailView: View {
    let drill: DrillModel
    let globalSettings = GlobalSettings()
    @Environment(\.dismiss) var dismiss
    @State private var isPlaying = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Video Demo Section
                    ZStack {
                        Color.gray.opacity(0.2)
                            .frame(height: 200)
                        
                        Button(action: { isPlaying.toggle() }) {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                    }
                    .cornerRadius(12)
                    
                    // Drill Information
                    VStack(alignment: .leading, spacing: 16) {
                        Text(drill.title)
                            .font(.title)
                            .bold()
                        
                        HStack(spacing: 20) {
                            InfoItem(title: "Sets", value: drill.sets)
                            InfoItem(title: "Reps", value: drill.reps)
                            InfoItem(title: "Duration", value: drill.duration)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(drill.description)
                                .foregroundColor(.secondary)
                        }
                        
                        // Tips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tips")
                                .font(.headline)
                            ForEach(drill.tips, id: \.self) { tip in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text(tip)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        // Equipment Needed
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Equipment Needed")
                                .font(.headline)
                            ForEach(drill.equipment, id: \.self) { item in
                                HStack(spacing: 8) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.secondary)
                                    Text(item)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            
            // Start Drill Button
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    // Handle start drill action
                }) {
                    Text("Start Drill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .cornerRadius(12)
                }
                .padding()
                .background(Color.white)
            }
        }
    }
}

struct InfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
//        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

//// Model for drill data
//struct DrillModel {
//    let title: String
//    let sets: String
//    let reps: String
//    let duration: String
//    let description: String
//    let tips: [String]
//    let equipment: [String]
//
//    static let example = DrillModel(
//        title: "Shooting Drill",
//        sets: "4",
//        reps: "2",
//        duration: "20min",
//        description: "This drill focuses on improving your shooting accuracy and power. Start by setting up cones in a zigzag pattern, dribble through them, and finish with a shot on goal.",
//        tips: [
//            "Keep your head down and eyes on the ball when shooting",
//            "Follow through with your kicking foot",
//            "Plant your non-kicking foot beside the ball",
//            "Strike the ball with your laces for power"
//        ],
//        equipment: [
//            "Soccer ball",
//            "Cones",
//            "Goal"
//        ]
//    )
//}
