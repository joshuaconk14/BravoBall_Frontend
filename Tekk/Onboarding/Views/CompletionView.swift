//
//  CompletionView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime

struct CompletionView: View {
    @ObservedObject var model: OnboardingModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image("BravoBallDog") // Replace with your actual mascot image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Creating your personalized training plan...")
                .font(.headline)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
            Button("Get Started") {
                withAnimation {
                    model.onboardingComplete = true
                }
            }
            .padding()
            .background(model.globalSettings.primaryYellowColor)
            .foregroundColor(.white)
            .cornerRadius(25)
        }
        .padding()
    }
}
