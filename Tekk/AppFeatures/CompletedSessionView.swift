//
//  CompletedSessionView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/10/25.
//

import SwiftUI
import RiveRuntime

struct CompletedSessionView: View {
    @ObservedObject var mainAppModel: MainAppModel
    
    @State private var weekCounter = 0

    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
                
                streakDisplay
                
                .padding(.top, 50)
                
                Spacer()
                    .frame(height: 50)
                
                Text("Completed drills:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 5)
                Text("Completed exercises:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 50)
                
                
                
                
                
                // test button
                Button(action: {
                    if mainAppModel.currentProgress >= 0 {
                            mainAppModel.currentProgress += 1
                            mainAppModel.addCheckMark = true
                            mainAppModel.streakIncrease += 1
                    }
                }) {
                    Text("Test")
                        .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                
                // week changer
                HStack {
                    Button(action: {
                        weekCounter -= 1 // no purpose yet
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.trailing, 10)
                    
                    Text("Week 1")
                        .font(.custom("Poppins-Bold", size: 23))
                    
                    Button(action: {
                        weekCounter += 1 // no purpose yet
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.leading, 10)
                }
                .padding(.bottom, 30)
                
                VStack(spacing: 5) {
                    ForEach(0..<7) { index in
                        WeekDisplayButton(
                            mainAppModel: mainAppModel,
                            text: getDayText(for: index),
                            showCheckmark: mainAppModel.currentProgress > index
                        )
                    }
                }
                .padding(.horizontal)
                
                
                

                

            }
        }
    }
    private var streakDisplay: some View {
        ZStack {
            RiveViewModel(fileName: "Streak_Diamond").view()
                .frame(width: 520, height: 350)
            HStack {
                Image("Streak_Flame")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                Text("\(mainAppModel.streakIncrease)")
                    .font(.custom("Poppins-Bold", size: 70))
                    .padding(.trailing, 20)
                    .foregroundColor(.red)
            }
        }
    }
    
    
    private func getDayText(for index: Int) -> String {
        switch index {
        case 0: return "Sunday"
        case 1: return "Monday"
        case 2: return "Tuesday"
        case 3: return "Wednesday"
        case 4: return "Thursday"
        case 5: return "Friday"
        case 6: return "Saturday"
        default: return ""
        }
    }
}



#Preview {
    let mockAppModel = MainAppModel()
    return CompletedSessionView(mainAppModel: mockAppModel)
}
