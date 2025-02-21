//
//  GroupDetailView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/21/25.
//

import SwiftUI

// MARK: - Group Detail View
struct GroupDetailView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let group: GroupModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    
                    Spacer()
                    
                    Button(action: {
                        appModel.viewState.showGroupFilterOptions = true
                    }) {
                        Image(systemName: "ellipsis")
                    }
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    
                }
                .padding()

                
                // Group Info Header
                VStack(spacing: 8) {
                    Image(systemName: "figure.soccer")
                        .font(.system(size: 40))
                    Text(group.name)
                        .font(.custom("Poppins-Bold", size: 24))
                    Text(group.description)
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding()
                
                // Drills List
                if group.drills.isEmpty {
                    Text("No drills saved yet")
                        .font(.custom("Poppins-Medium", size: 16))
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(group.drills) { drill in
                            DrillRow(appModel: appModel, sessionModel: sessionModel, drill: drill)
                        }
                    }
                }
                Spacer()
            }
            // Sheet pop-up for filter option button
            .sheet(isPresented: $appModel.viewState.showGroupFilterOptions) {
                GroupFilterOptions(
                    appModel: appModel,
                    sessionModel: sessionModel
                )
                .presentationDragIndicator(.hidden)
                .presentationDetents([.height(200)])
            }
    }
}
