//
//  SavedDrillsView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI

struct SavedDrillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @State private var showCreateGroup: Bool = false
    @State private var showGroupDetails: Bool = false
    @State private var savedGroupName: String = ""
    @State private var savedGroupDescription: String = ""
    @State private var selectedGroup: GroupModel? = nil
    
    // MARK: Main view
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        Spacer()
                        
                        // Progress header
                        Text("Saved Drills")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.black)
                            .padding()
                        
                        Spacer()
                        
                        Button(action: {
                            showCreateGroup = true
                        }) {
                            Text("Create")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    
                    
                    // Groups Display
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(sessionModel.savedDrills) { group in
                                GroupCard(group: group)
                                    .onTapGesture {
                                        selectedGroup = group
                                    }
                            }
                        }
                        .padding()
                    }
                }
                
                if showCreateGroup {
                    createGroupPrompt
                }
                
            }
            .sheet(item: $selectedGroup) { group in
                GroupDetailView(group: group)
            }
        }
    }
    
    // MARK: Create group prompt
    private var createGroupPrompt: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    savedGroupName = ""
                    savedGroupDescription = ""
                    showCreateGroup = false
                }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            savedGroupName = ""
                            savedGroupDescription = ""
                            showCreateGroup = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Create group")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                TextField("Name", text: $savedGroupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                TextField("Description", text: $savedGroupDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                Button(action: {
                    withAnimation {
                        createGroup(
                            name: savedGroupName,
                            description: savedGroupDescription
                        )
                        showCreateGroup = false
                    }
                }) {
                    Text("Save")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(appModel.globalSettings.primaryYellowColor)
                        .cornerRadius(8)
                }
                .disabled(savedGroupName.isEmpty || savedGroupDescription.isEmpty)
                .padding(.top, 16)
            }
            .padding()
            .frame(width: 300, height: 270)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
    
    func createGroup(name: String, description: String) {
        let groupModel = GroupModel(
            name: name,
            description: description,
            drills: []
        )
        
        sessionModel.savedDrills.append(groupModel)
    }
}

// MARK: - Group Card
struct GroupCard: View {
    let group: GroupModel
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.soccer")
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            Text(group.name)
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .lineLimit(1)
            
            Text(group.description)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
            
            Text("\(group.drills.count) drills")
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(height: 160)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

// MARK: - Group Detail View
struct GroupDetailView: View {
    let group: GroupModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .padding()
                }
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
                            DrillRow(drill: drill)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Drill Row
struct DrillRow: View {
    let drill: DrillModel
    
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
                Text(drill.description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    let mockSesGenModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    // Create a mock drill
        let mockDrill = DrillModel(
            title: "Quick Passing",
            sets: "3",
            reps: "5",
            duration: "15 minutes",
            description: "Short passing drill to improve accuracy",
            tips: ["no funny beezness"],
            equipment: ["ball", "cones"]
        )
        
        // Create a mock group with the drill
        let mockGroup = GroupModel(
            name: "My First Group",
            description: "Collection of passing drills",
            drills: [mockDrill]
        )
        
        // Add the mock group to savedDrills
        mockSesGenModel.savedDrills = [mockGroup]
    
    
    return SavedDrillsView(appModel: mockAppModel, sessionModel: mockSesGenModel)
}
