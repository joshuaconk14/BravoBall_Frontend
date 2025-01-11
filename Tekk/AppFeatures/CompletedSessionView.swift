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
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    RiveViewModel(fileName: "Streak_Diamond").view()
                        .frame(width: 520, height: 350)
                    HStack {
                        Image("Streak_Flame")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
//                            .padding()
                        Text("7")
                            .font(.custom("Poppins-Bold", size: 70))
                            .padding(.trailing, 20)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 50)
                
                Spacer()
                    .frame(height: 50)
                
                Text("Completed drills:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 5)
                Text("Completed exercises:")
                    .font(.custom("Poppins-Bold", size: 18))
                    .padding(.bottom, 50)
                
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.trailing, 10)
                    
                    Text("Week 1")
                        .font(.custom("Poppins-Bold", size: 23))
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "chevron.right")
                    }
                    .foregroundColor(mainAppModel.globalSettings.primaryDarkColor)
                    .padding(.leading, 10)
                }
                .padding(.bottom, 30)
                
                VStack(spacing: 5) {
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Monday"
                    )
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Tuesday"
                    )
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Wednesday"
                    )
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Thursday"
                    )
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Friday"
                    )
                    WeekDisplayButton(
                        mainAppModel: mainAppModel,
                        text: "Saturday"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    return CompletedSessionView(mainAppModel: mockAppModel)
}
