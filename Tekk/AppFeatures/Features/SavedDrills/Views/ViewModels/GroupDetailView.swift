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


// TODO: enum this or combine it with the filteroptions structure

// MARK: Group Filter Options
struct GroupFilterOptions: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    // TODO: case enums for neatness
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                
                // TODO: action for this
                
                withAnimation {
                    appModel.viewState.showGroupFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Delete Group")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Button(action: {
                
                // TODO: action for this
                
                withAnimation {
                    appModel.viewState.showGroupFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "gearshape")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Edit Group")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Button(action: {
                
                // TODO: action for this
                
                withAnimation(.spring(dampingFraction: 0.7)) {
                    appModel.viewState.showGroupFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Add to Group")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .padding(8)
        .background(Color.white)
        .frame(maxWidth: .infinity)

    }
}
