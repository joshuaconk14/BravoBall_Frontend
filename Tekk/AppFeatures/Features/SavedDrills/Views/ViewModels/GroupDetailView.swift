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
    @State private var showAddDrillSheet = false
    
    var body: some View {
            ZStack {
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
                        
                        Spacer()
                } else {
                    List {
                        ForEach(group.drills) { drill in
                            DrillRow(appModel: appModel, sessionModel: sessionModel, drill: drill)
                        }
                    }
                }
                }
                
                // Floating add button
                VStack {
                    Spacer()
                    HStack {
                Spacer()
                        Button(action: {
                            showAddDrillSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.black)
                                .frame(width: 56, height: 56)
                                .background(appModel.globalSettings.primaryYellowColor)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
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
            // Sheet for adding drills
            .sheet(isPresented: $showAddDrillSheet) {
                DrillSearchView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    onDrillsSelected: { selectedDrills in
                        // Add selected drills to the group
                        for drill in selectedDrills {
                            sessionModel.addDrillToGroup(drill: drill, groupId: group.id)
                        }
                    },
                    title: "Add Drills to \(group.name)",
                    actionButtonText: { count in
                        "Add \(count) \(count == 1 ? "Drill" : "Drills") to Group"
                    },
                    filterDrills: { drill in
                        false // No drills are disabled
                    },
                    isDrillSelected: { drill in
                        // Check if the drill is already in the group
                        group.drills.contains(drill)
                    },
                    dismiss: { showAddDrillSheet = false }
                )
            }
            .onAppear {
                // Set up notification observer
                NotificationCenter.default.addObserver(
                    forName: Notification.Name("ShowAddDrillSheet"),
                    object: nil,
                    queue: .main
                ) { _ in
                    showAddDrillSheet = true
                }
            }
            .onDisappear {
                // Remove notification observer
                NotificationCenter.default.removeObserver(
                    self,
                    name: Notification.Name("ShowAddDrillSheet"),
                    object: nil
                )
            }
    }
}

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
                // Show add drill sheet
                withAnimation(.spring(dampingFraction: 0.7)) {
                    appModel.viewState.showGroupFilterOptions = false
                    
                    // Delay to allow the first sheet to close smoothly
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        // This will be handled in the parent view by binding to showAddDrillSheet
                        NotificationCenter.default.post(name: Notification.Name("ShowAddDrillSheet"), object: nil)
                    }
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
