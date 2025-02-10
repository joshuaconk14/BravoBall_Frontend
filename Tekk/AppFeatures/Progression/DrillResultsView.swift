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
    @ObservedObject var sessionModel: SessionGeneratorModel
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
                    
                    
                    ZStack {
                        CircularProgressView(appModel: appModel, progress: Double(session.totalCompletedDrills) / Double(session.totalDrills))
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
                    

                    // MARK: Fix this
                    ForEach(session.drills, id: \.drill.id) { drill in
                            ZStack {
                                if drill.isCompleted {
                                    RiveViewModel(fileName: "Drill_Card_Complete").view()
                                        .frame(width: 330, height: 180)
                                } else {
                                    RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                                        .frame(width: 330, height: 180)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                        
                                    Text("Drill: \(drill.drill.title)")
                                            .font(.custom("Poppins-Bold", size: 18))
                                    Text("Skill: \(drill.drill.skill)")
                                        HStack(spacing: 20) {
                                            Text("Duration: \(drill.duration)min")
                                            Text("Sets: \(drill.drill.sets)")
                                            Text("Reps: \(drill.drill.reps)")
                                        }
                                    Text("Equipment: \(drill.drill.equipment.joined(separator: ", "))")
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
    @ObservedObject var appModel: MainAppModel
    let progress: Double
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: appModel.viewState.showHomePage ? 20 : 10)
                .opacity(0.2)
                .foregroundColor(Color.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(animatedProgress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: appModel.viewState.showHomePage ? 20 : 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(appModel.globalSettings.primaryYellowColor)
                .rotationEffect(Angle(degrees: 270.0))
        }
        // When progress first appears
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
        // When progress changes
        .onChange(of: progress) {
            withAnimation(.easeOut(duration: 0.8)) {
                animatedProgress = progress
            }
        }
    }
}

#Preview {
    let mockMainAppModel = MainAppModel()
    let mockSesGenModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    // Create mock drills using EditableDrillModel
    let mockDrills = [
        EditableDrillModel(
            drill: DrillModel(
                title: "Speed Dribbling",
                skill: "Ball Control",
                sets: 4,
                reps: 10,
                duration: 20,
                description: "Improve your dribbling speed and control",
                tips: ["Keep the ball close", "Look up while dribbling"],
                equipment: ["Ball", "Cones"],
                trainingStyle: "High Intensity",
                difficulty: "Intermediate"
            ),
            sets: 4,
            reps: 10,
            duration: 20,
            isCompleted: true
        ),
        EditableDrillModel(
            drill: DrillModel(
                title: "V-Taps",
                skill: "Ball Control",
                sets: 4,
                reps: 10,
                duration: 20,
                description: "Master the V-tap technique for better ball control",
                tips: ["Quick touches", "Maintain balance"],
                equipment: ["Ball", "Cones"],
                trainingStyle: "Medium Intensity",
                difficulty: "Beginner"
            ),
            sets: 4,
            reps: 10,
            duration: 20,
            isCompleted: true
        ),
        EditableDrillModel(
            drill: DrillModel(
                title: "Ronaldinho Drill",
                skill: "Ball Control",
                sets: 4,
                reps: 10,
                duration: 20,
                description: "Practice advanced ball control techniques",
                tips: ["Stay light on your feet", "Practice both directions"],
                equipment: ["Ball", "Cones"],
                trainingStyle: "High Intensity",
                difficulty: "Advanced"
            ),
            sets: 4,
            reps: 10,
            duration: 20,
            isCompleted: false
        ),
        EditableDrillModel(
            drill: DrillModel(
                title: "Cone Weaves",
                skill: "Ball Control",
                sets: 4,
                reps: 10,
                duration: 20,
                description: "Improve close control through cone weaving",
                tips: ["Use both feet", "Keep head up"],
                equipment: ["Ball", "Cones"],
                trainingStyle: "Medium Intensity",
                difficulty: "Beginner"
            ),
            sets: 4,
            reps: 10,
            duration: 20,
            isCompleted: true
        )
    ]
    
    // Create mock session with EditableDrillModel array
    mockMainAppModel.selectedSession = MainAppModel.CompletedSession(
        date: Date(),
        drills: mockDrills,
        totalCompletedDrills: 3,
        totalDrills: 4
    )
    
    return DrillResultsView(appModel: mockMainAppModel, sessionModel: mockSesGenModel)
}
