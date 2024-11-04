//
//  QuestionnaireNavigationButtons.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI

struct QuestionnaireNavigationButtons: View {
    @EnvironmentObject var globalSettings: GlobalSettings
    @EnvironmentObject var questionnaireCoordinator: QuestionnaireCoordinator
    
    let isLastStep: Bool
    let handleBack: () -> Void
    let handleNext: () -> Void
    
    var body: some View {
        VStack {
            // Back button
            HStack {
                Button(action: handleBack) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding()
                }
                .padding(.bottom, 725)
                Spacer()
            }
            
            // Next/Finish button
            Button(action: handleNext) {
                Text(isLastStep ? "Finish" : "Next")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.top, 700)
        }
    }
}
