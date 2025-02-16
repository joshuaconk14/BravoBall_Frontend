//
//  SessionCompleteView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/15/25.
//

import SwiftUI
import RiveRuntime

struct SessionCompleteView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            
            // Sky background color
            Color(appModel.globalSettings.primaryYellowColor)
                .ignoresSafeArea()
            
            VStack {
                Text("You've completed your session!")
                
                Button(action: {
                    appModel.viewState.showSessionComplete = false
                }) {
                    ZStack {
                        RiveViewModel(fileName: "Golden_Button").view()
                            .frame(width: 120, height: 40)
                        
                        Text("Back to home page")
                            .font(.custom("Poppins-Bold", size: 10))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .padding(.bottom, 10)
                    }
                }
            }
        }
        
        

        
    }
}
