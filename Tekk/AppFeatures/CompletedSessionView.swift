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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 5) {
                
                streakDisplay
                
                Text("Completed drills:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 5)
                Text("Completed exercises:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 10)
                
                
                
                
                
                // test button
                Button(action: {
                    if mainAppModel.currentDay >= 0 {
                        mainAppModel.completedSessionIndicator()
                        mainAppModel.addCheckMark = true
                        mainAppModel.streakIncrease += 1
                        mainAppModel.interactedDayShowGold = true
                    }
                }) {
                    Text("Test")
                        .foregroundColor(Color.blue)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                
                // week changer
                HStack {
                    Button(action: {
                        mainAppModel.currentWeek -= 1
                    }) {
                        Image(systemName: "chevron.left")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.trailing, 10)
                    .disabled(mainAppModel.currentWeek == 0)
                    
                    Text("Week \(mainAppModel.currentWeek + 1)")
                        .font(.custom("Poppins-Bold", size: 23))
                    
                    Button(action: {
                        mainAppModel.currentWeek += 1
                    }) {
                        Image(systemName: "chevron.right")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.leading, 10)
                    .disabled(mainAppModel.currentWeek == mainAppModel.completedWeeks.count)
                }
                .padding(.bottom, 30)
                
                
                // For each week display button:
                VStack(spacing: 5) {
                    ForEach(0..<7) { index in
                        WeekDisplayButton(
                            mainAppModel: mainAppModel,
                            text: getDayText(for: index),
                            showCheckmark: mainAppModel.currentDay > index, // boolean goes through each index / case #
                            interactedDay: mainAppModel.currentDay + 1 > index // boolean goes through each index / case #
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
                .aspectRatio(contentMode: .fit)  // For diff screen width so object does not go out screen
                .frame(maxWidth: .infinity)
                .padding()
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
        .padding()
    }
    
    // returns the text for each day
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
