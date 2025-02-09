//
//  DrillFollowAlongView.swift
//  BravoBall
//
//  Created by Jordan on 1/15/25.
//

import SwiftUI

struct DrillFollowAlongView: View {
    let drill: DrillModel
    @ObservedObject var appModel: MainAppModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval
    @State private var totalSets: Double
    @State private var countdownValue: Int?
    @State private var displayCountdown: Bool = false // MARK: TESTING
    @State private var timer: Timer?
    
    // Initialize states to use drill values
    init(drill: DrillModel, appModel: MainAppModel) {
        self.drill = drill
        self.appModel = appModel
        
        let totalSets = Double(drill.sets)
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
                // Top timer section
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Time")
                            .font(.custom("Poppins-Regular", size: 14))
                            .foregroundColor(.gray)
                        Text(timeString(from: elapsedTime))
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    Spacer()
                    
                    
                    
                    CircularProgressView(appModel: appModel, progress: appModel.setsDone / totalSets, color: appModel.globalSettings.primaryYellowColor)
                        .frame(width: 50, height: 80)
                        .padding()
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                
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
                
                
                // End Drill button at bottom
                Button(action: endSession) {
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
                if appModel.setsDone < totalSets {
                    appModel.setsDone += 1.0
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
    
    private func endSession() {
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
    DrillFollowAlongView(drill: DrillModel(
        title: "Test Drill",
        skill: "Passing",
        sets: 3,
        reps: 10,
        duration: 15,
        description: "Test description",
        tips: ["Tip 1", "Tip 2"],
        equipment: ["Ball"],
        trainingStyle: "Medium Intensity",
        difficulty: "Beginner"
    ), appModel: mockMainAppModel)
}


