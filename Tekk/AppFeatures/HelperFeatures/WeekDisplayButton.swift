//
//  WeekDisplayButton.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/10/25.
//

import SwiftUI
import RiveRuntime


struct WeekDisplayButton: View {
    @ObservedObject var mainAppModel: MainAppModel
    
    let text: String
    let showCheckmark: Bool
    let interactedDay: Bool
    
    
    var body: some View {
        Button(action: {
            // Add your button action here
        }) {
            ZStack {
                if interactedDay {
                    RiveViewModel(fileName: "Week_Progress_Box_Interacted").view()
                        .frame(width: 360, height: 180)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .padding(.horizontal)

                    
                    if showCheckmark {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                            .font(.system(size: 30))
                            .padding(.bottom, 150)
                            .padding(.leading, 200)
                            .foregroundColor(Color.green)
                    }
                    HStack {
                        Spacer()
                            .frame(width: 90)
                        Text(text)
                            .font(.custom("Poppins-Bold", size: 18))
                            .padding(.bottom, 10)
                            .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    }
                } else {
                    RiveViewModel(fileName: "Week_Progress_Box").view()
                        .frame(width: 360, height: 180)
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .padding(.horizontal)
                    
                    HStack {
                        Spacer()
                            .frame(width: 90)
                        Text(text)
                            .font(.custom("Poppins-Bold", size: 18))
                            .padding(.bottom, 10)
                            .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    }
                }
            }
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    
    return WeekDisplayButton(
        mainAppModel: mockAppModel,
        text: "Monday",
        showCheckmark: true,
        interactedDay: true
    )
}
