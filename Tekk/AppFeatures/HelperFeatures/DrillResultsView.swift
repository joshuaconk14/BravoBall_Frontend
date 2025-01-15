//
//  DrillResultsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/15/25.
//

import SwiftUI

struct DrillResultsView: View {
    @ObservedObject var mainAppModel: MainAppModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                backButton
                Spacer()
            }
            .padding()
            
            Text("Drill shower")
            Spacer()
        }
    }
    
    private var backButton: some View {
        Button(action: {
            mainAppModel.showDrillShower = false
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(mainAppModel.globalSettings.primaryYellowColor)
            }
        }
    }
}
