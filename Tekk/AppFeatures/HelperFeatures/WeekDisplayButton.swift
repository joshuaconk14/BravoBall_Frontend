//
//  WeekDisplayButton.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/12/25.
//

import SwiftUI
import RiveRuntime


struct WeekDisplayButton: View {
    @ObservedObject var appModel: MainAppModel
    
    let text: String
    let date: Date
    let dayWithScore: Bool
    let highlightedDay: Bool
    
    var body: some View {
        Button(action: {
            if dayWithScore {
                // Retrieving session from stored data
                if let session = appModel.getSessionForDate(date) {
                    appModel.selectedSession = session
                    appModel.showDrillResults = true
                }
            }
        }) {
            ZStack {
                if dayWithScore {
                    ZStack {
                        RiveViewModel(fileName: "Day_High_Score").view()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fit)
                            .clipped()

                        Text(text)
                            .font(.custom("Poppins-Bold", size: 30))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }

                } else {
                    RiveViewModel(fileName: "Day_Null").view()
                        .frame(width: 60, height: 60)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    
                    if highlightedDay {
                        Text(text)
                            .font(.custom("Poppins-Bold", size: 30))
                            .foregroundColor(Color.white)
                            .background(
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 42, height: 42)
                            )
                    } else {
                        Text(text)
                            .font(.custom("Poppins-Bold", size: 30))
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }
                }
            }
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    
    return WeekDisplayButton(
        appModel: mockAppModel,
        text: "34",
        date: Date(),
        dayWithScore: true,
        highlightedDay: true
    )
}
