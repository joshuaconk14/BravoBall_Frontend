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
                AddDrillsToGroupSheet(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    group: group,
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

// View for adding drills to a group
struct AddDrillsToGroupSheet: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let group: GroupModel
    let dismiss: () -> Void
    @State private var searchText: String = ""
    @State private var selectedDrills: [DrillModel] = []
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Add Drills to \(group.name)")
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .font(.custom("Poppins-Bold", size: 16))
                    .padding(.leading, 70)
                Spacer()
                Button("Done") {
                    dismiss()
                }
                .padding()
                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                .font(.custom("Poppins-Bold", size: 16))
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search drills...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focused($isFocused)
                    .tint(appModel.globalSettings.primaryYellowColor)

                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isFocused ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
            )
            .cornerRadius(20)
            .padding()
            
            // Drills list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredDrills) { drill in
                        DrillRowForGroup(
                            drill: drill, 
                            isSelected: selectedDrills.contains(drill),
                            isInGroup: group.drills.contains(drill),
                            onSelect: { toggleDrillSelection(drill) }
                        )
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
            
            // Add button
            if !selectedDrills.isEmpty {
                Button(action: {
                    addSelectedDrillsToGroup()
                }) {
                    Text("Add \(selectedDrills.count) \(selectedDrills.count == 1 ? "Drill" : "Drills") to Group")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(appModel.globalSettings.primaryYellowColor)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
    }
    
    // Filtered drills based on search text
    var filteredDrills: [DrillModel] {
        if searchText.isEmpty {
            return SessionGeneratorModel.testDrills.filter { drill in
                !group.drills.contains(drill)
            }
        } else {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.title.lowercased().contains(searchText.lowercased()) && !group.drills.contains(drill)
            }
        }
    }
    
    // Toggle drill selection
    func toggleDrillSelection(_ drill: DrillModel) {
        if selectedDrills.contains(drill) {
            selectedDrills.removeAll(where: { $0.id == drill.id })
        } else {
            selectedDrills.append(drill)
        }
    }
    
    // Add selected drills to the group
    func addSelectedDrillsToGroup() {
        for drill in selectedDrills {
            sessionModel.addDrillToGroup(drill: drill, groupId: group.id)
        }
        dismiss()
    }
}

// Simplified drill row for group selection
struct DrillRowForGroup: View {
    let drill: DrillModel
    let isSelected: Bool
    let isInGroup: Bool
    let onSelect: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "figure.soccer")
                .font(.system(size: 24))
                .foregroundColor(.black)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(drill.title)
                    .font(.custom("Poppins-Bold", size: 14))
                    .foregroundColor(.black)
                Text(drill.description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if isInGroup {
                Text("Already in group")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.gray)
            } else {
                Button(action: onSelect) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isSelected ? Color.yellow : Color.clear)
                            .stroke(isSelected ? Color.yellow : Color.black, lineWidth: 2)
                            .frame(width: 20, height: 20)
                        
                        if isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 12, weight: .bold))
                        }
                    }
                }
            }
        }
        .padding(.vertical, 8)
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
