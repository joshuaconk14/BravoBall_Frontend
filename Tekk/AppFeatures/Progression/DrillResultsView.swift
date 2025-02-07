//
//  DrillResultsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/15/25.
//

import SwiftUI
import RiveRuntime


struct DrillResultsView: View {
    @ObservedObject var appModel: MainAppModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showScore: Bool = false
    
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    backButton
                    Spacer()
                }
                .padding()
                
                Spacer ()
                
                if let session = appModel.selectedSession {
                    Text("\(formatDate(session.date))")
                        .padding()
                        .padding(.top, 20)
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)

                    Text("Score:")
                        .padding()
                        .font(.custom("Poppins-Bold", size: 30))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    
                    let score = Double(session.totalCompletedDrills) / Double(session.totalDrills)
                    
                    ZStack {
                        CircularProgressView(progress: score, color: appModel.globalSettings.primaryYellowColor)
                            .frame(width: 200, height: 200)
                        
                        Text("\(session.totalCompletedDrills) / \(session.totalDrills)")
                            .padding()
                            .font(.custom("Poppins-Bold", size: 40))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .opacity(showScore ? 1 : 0)
                            .animation(.easeIn.delay(0.8), value: showScore)
                    }
                    .padding()
                    .padding(.bottom, 70)
                    .onAppear {
                        showScore = true
                    }
                    
                    Text("Drills:")
                        .padding()
                        .font(.custom("Poppins-Bold", size: 30))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    

                        ForEach(session.drills, id: \.name) { drill in
                            ZStack {
                                if drill.isCompleted {
                                    RiveViewModel(fileName: "Drill_Card_Complete").view()
                                        .frame(width: 330, height: 180)
                                } else {
                                    RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                                        .frame(width: 330, height: 180)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                        
                                        Text("Drill: \(drill.name)")
                                            .font(.custom("Poppins-Bold", size: 18))
                                        Text("Skill: \(drill.skill)")
                                        HStack(spacing: 20) {
                                            Text("Duration: \(drill.duration)min")
                                            Text("Sets: \(drill.sets)")
                                            Text("Reps: \(drill.reps)")
                                        }
                                        Text("Equipment: \(drill.equipment.joined(separator: ", "))")
                                }
                                .padding()
                                .font(.custom("Poppins-Regular", size: 14))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            }
                        }
                        .padding(.horizontal)
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
    
    private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        }
}


// Score View
struct CircularProgressView: View {
    let progress: Double
    let color: Color
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .opacity(0.2)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(animatedProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
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
        ),
        MainAppModel.DrillData(
            name: "V-Taps",
            skill: "Ball Control",
            duration: 20,
            sets: 4,
            reps: 10,
            equipment: ["Ball", "Cones"],
            isCompleted: true
        ),
        MainAppModel.DrillData(
            name: "Ronaldinho Drill",
            skill: "Ball Control",
            duration: 20,
            sets: 4,
            reps: 10,
            equipment: ["Ball", "Cones"],
            isCompleted: false
        ),
        MainAppModel.DrillData(
            name: "Cone Weaves",
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
        drills: mockDrills, // Pass the combined drills array
        totalCompletedDrills: 3,
        totalDrills: 4
    )
    
    return DrillResultsView(appModel: mockMainAppModel)
}
