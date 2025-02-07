//
//  DrillFollowAlongView.swift
//  BravoBall
//
//  Created by Jordan on 1/15/25.
//

import SwiftUI

struct DrillFollowAlongView: View {
    let drill: DrillModel
    @Environment(\.dismiss) private var dismiss
    @State private var isPlaying = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
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
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
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
                .padding(.bottom, 40)
            }
        }
        .statusBar(hidden: false)
        .navigationBarHidden(true)
    }
    
    private func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            startTimer()
        } else {
            stopTimer()
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
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
    ))
}


