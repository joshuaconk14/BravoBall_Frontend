//
//  DrillFollowAlongView.swift
//  BravoBall
//
//  Created by Jordan on 1/15/25.
//

import SwiftUI

struct DrillFollowAlongView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var editableDrill: EditableDrillModel
    
    @State private var showDrillDetailView: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval
    @State private var setsDone: Double = 0.0
    @State private var totalSets: Double
    @State private var countdownValue: Int?
    @State private var displayCountdown: Bool = false // TESTING
    @State private var timer: Timer?
    
    
    
    // Initialize states to use drill values
    init(appModel: MainAppModel, sessionModel: SessionGeneratorModel, editableDrill: Binding<EditableDrillModel>) {
        self.appModel = appModel
        self.sessionModel = sessionModel
        self._editableDrill = editableDrill
        
        
        let totalSets = Double(editableDrill.wrappedValue.drill.sets)
        _totalSets = State(initialValue: totalSets)
        
        
        
        // MARK: PRODUCTION
//        let initialTime = TimeInterval(drill.duration) * 60.00 / TimeInterval(drill.sets)
        // MARK: TESTING
        let initialTime = 1.0
        _elapsedTime = State(initialValue: initialTime)
        
    }

    
    var body: some View {
        
        
        
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()
            
            
            VStack(spacing: 0) {
                HStack {
                    
                    HStack {
                        backButton
                        Spacer()
                    }

                    Spacer()
                    
                    Button(action : { showDrillDetailView = true}) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Text("\(editableDrill.drill.title)")
                        .padding(.horizontal)
                    
                    
                    CircularProgressView(appModel: appModel, progress: setsDone / totalSets)
                        .frame(width: 50, height: 80)
                        .padding()
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                
                HStack {
                    Spacer()
                    
                    // Top timer section
                    VStack(alignment: .center, spacing: 4) {
                        Text("Time")
                            .font(.custom("Poppins-Regular", size: 24))
                            .foregroundColor(.gray)
                        Text(timeString(from: elapsedTime))
                            .font(.custom("Poppins-Bold", size: 26))
                    }
                    
                    Spacer()
                }
                
                
                Spacer()
                
                // Video preview in the middle
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .aspectRatio(16/9, contentMode: .fit)
                        .cornerRadius(12)
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: togglePlayPause) {
                    Circle()
                        .fill(.white)
                        .frame(width: 60, height: 60)
                        .shadow(color: .black.opacity(0.1), radius: 10)
                        .overlay(
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        )
                        .padding(.bottom, 75)
                }
                
                Spacer()
                
                if doneWithDrill() {
                    Button(action: {
                        handleDrillCompletion()
                        endDrill()
                        
                    }
                            
                    ){
                        Text("End Drill")
                            .font(.custom("Poppins-Bold", size: 16))
                            .foregroundColor(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color.red)
                            )
                    }
                    .padding(.horizontal, 20)
                }
                
//                if doneWithSession() {
//                    Button(action: {
//                        handleSessionCompletion()
//                        endDrill()
//
//                    }
//
//                    ){
//                        Text("End Drill")
//                            .font(.custom("Poppins-Bold", size: 16))
//                            .foregroundColor(.white)
//                            .frame(height: 44)
//                            .frame(maxWidth: .infinity)
//                            .background(
//                                RoundedRectangle(cornerRadius: 22)
//                                    .fill(Color.red)
//                            )
//                    }
//                    .padding(.horizontal, 20)
//                }
                
            }
            
            // Add countdown overlay
            if let countdown = countdownValue {
                Text("\(countdown)")
                    .font(.custom("Poppins-Bold", size: 72))
                    .foregroundColor(.black)
                    .padding(.bottom, 550)
            }
        }
        .statusBar(hidden: false)
        .navigationBarHidden(true)
        .sheet(isPresented: $showDrillDetailView) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: editableDrill.drill)
        }
    }
    
    private var backButton: some View {
        Button(action: {
            stopTimer()
            dismiss()
        }) {
            HStack {
                Image(systemName: "xmark")
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
            }
        }
    }
    
    private func doneWithDrill() -> Bool {
        return totalSets == setsDone
    }
    
    private func handleDrillCompletion() {
        editableDrill.isCompleted = true
    }
    
    private func doneWithSession() -> Bool {
//        appModel.addCompletedSession(
//            date: Date(),
//            drills: sessionModel.orderedDrills,
//            totalCompletedDrills: Int(setsDone),
//            totalDrills: Int(totalSets)
//        )
//        for drill in sessionModel.orderedDrills {
//            if drill.totalCompletedDrills == drill.totalDrills {
//                return true
//            }
//            return false
//        }
        return totalSets == setsDone
    }

    private func handleSessionCompletion() {
        //        appModel.addCompletedSession(
        //            date: Date(),
        //            drills: sessionModel.orderedDrills,
        //            totalCompletedDrills: Int(setsDone),
        //            totalDrills: Int(totalSets)
        //        )
        //        for drill in sessionModel.orderedDrills {
        //            if drill.totalCompletedDrills == drill.totalDrills {
        //                return true
        //            }
        //            return false
    }
    

    private func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            if displayCountdown {
                startCountdown()
            } else {
                startTimer()
            }
        } else {
            stopTimer()
        }
    }
    
    private func startCountdown() {
        countdownValue = 3
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if let count = countdownValue {
                if count > 1 {
                    countdownValue = count - 1
                } else {
                    timer.invalidate()
                    countdownValue = nil
                    displayCountdown = false
                    startTimer()
                }
            }
        }
    }
    
    private func startTimer() {
        let restartTime = elapsedTime
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if elapsedTime > 0 {
                elapsedTime -= 1
            } else {
                stopTimer()
                if setsDone < totalSets {
                    setsDone += 1.0
                }
                elapsedTime = restartTime
                isPlaying = false
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func endDrill() {
        stopTimer()
        dismiss()
        
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    let mockMainAppModel = MainAppModel()
    let mockSessionModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    let mockDrill = EditableDrillModel(
        drill: DrillModel(
            title: "Test Drill",
            skill: "Passing",
            sets: 2,
            reps: 10,
            duration: 15,
            description: "Test description",
            tips: ["Tip 1", "Tip 2"],
            equipment: ["Ball"],
            trainingStyle: "Medium Intensity",
            difficulty: "Beginner"
        ),
        sets: 2,
        reps: 10,
        duration: 15,
        isCompleted: false
    )
    
    DrillFollowAlongView(
        appModel: mockMainAppModel,
        sessionModel: mockSessionModel,
        editableDrill: .constant(mockDrill)
    )
}
