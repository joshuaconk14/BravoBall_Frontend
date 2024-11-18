//
//  HomeHomeProgramView.swift
//  BravoBall
//
//  Created by Jordan on 11/3/24.
//
// This file contains the view for the home program screen.

import Foundation
import SwiftUI
import RiveRuntime

struct HomeProgramView: View {
    @StateObject private var viewModel = ProgramViewModel()
    @StateObject private var globalSettings = GlobalSettings()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let program = viewModel.program {
                    ProgramContentView(program: program)
                } else if viewModel.error != nil {
                    Text("Error loading program")
                }
            }
        }
        .onAppear {
            viewModel.fetchProgram(userId: 1) // Replace with actual user ID
        }
    }
}

//struct DrillCardView: View {
//    @StateObject private var globalSettings = GlobalSettings()
//    let drill: HomeProgramView.DrillCard
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                Text(drill.title)
//                    .font(.custom("Poppins-Bold", size: 18))
//                    .foregroundColor(globalSettings.primaryDarkColor)
//                
//                Spacer()
//                
//                Text(drill.duration)
//                    .font(.custom("Poppins-Regular", size: 14))
//                    .foregroundColor(.gray)
//            }
//            
//            Text(drill.description)
//                .font(.custom("Poppins-Regular", size: 14))
//                .foregroundColor(.gray)
//            
//            Button(action: {}) {
//                Text("Start Drill")
//                    .font(.custom("Poppins-Bold", size: 16))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(globalSettings.primaryYellowColor)
//                    .cornerRadius(20)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(15)
//        .overlay(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//        )
//    }
//}


struct HomeProgramView_Previews: PreviewProvider {
    static var previews: some View {
        HomeProgramView()
    }
}
