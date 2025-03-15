//
//  DrillCard.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import SwiftUI
import RiveRuntime

// Mutable drill card

struct DrillCard: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var editableDrill: EditableDrillModel
    
    
    var body: some View {
        Button(action: {
            sessionModel.selectedDrillForEditing = editableDrill
            appModel.viewState.showingDrillDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 320, height: 170)
                HStack {
                        // Drag handle
                        Image(systemName: "line.3.horizontal")
                            .padding()
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                            .font(.system(size: 14))
                            .padding(.trailing, 8)
                        
                    Image(systemName: "figure.soccer")
                            .font(.system(size: 24))
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(editableDrill.drill.title)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        Text("\(editableDrill.drill.sets) sets - \(editableDrill.drill.reps) reps - \(editableDrill.drill.duration)")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                
                Spacer()
                
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $appModel.viewState.showingDrillDetail) {
            if let selectedDrill = sessionModel.selectedDrillForEditing,
               let index = sessionModel.orderedSessionDrills.firstIndex(where: {$0.drill.id == selectedDrill.drill.id}) {
                    EditingDrillView(
                        appModel: appModel,
                        sessionModel: sessionModel,
                        editableDrill: $sessionModel.orderedSessionDrills[index])
                }
            
        }
    }
}
