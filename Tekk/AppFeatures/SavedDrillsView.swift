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
                    
                    AllGroupsDisplay(appModel: appModel, sessionModel: sessionModel, selectedGroup: $selectedGroup)

                }
                
                if showCreateGroup {
                    createGroupPrompt
                }
                
            }
            .sheet(item: $selectedGroup) { group in
                GroupDetailView(appModel: appModel, sessionModel: sessionModel, group: group)
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
                        sessionModel.createGroup(
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

}

// MARK: - All Groups Display
struct AllGroupsDisplay: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var selectedGroup: GroupModel?
    
    var body: some View {
        // Groups Display
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                
                LikedGroupCard(sessionModel: sessionModel)
                    .onTapGesture {
                        selectedGroup = sessionModel.likedDrillsGroup
                    }
                
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
        .frame(width: 150, height: 170)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}

// MARK: - Group Detail View
struct GroupDetailView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let group: GroupModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    
                    Button("Done") {
                        dismiss()
                    }
                    .padding()
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
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
                            DrillRow(appModel: appModel, sessionModel: sessionModel, drill: drill)
                        }
                    }
                }
                Spacer()
            }
    }
}

// MARK: - Liked Group Card
struct LikedGroupCard: View {
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundColor(.black)
            
            Text("\(sessionModel.likedDrillsGroup.name)")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.black)
                .lineLimit(1)
            
            
            Text("\(sessionModel.likedDrillsGroup.drills.count) drills")
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 150, height: 170)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5)
    }
}


// MARK: - Drill Row
struct DrillRow: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    @State var showDrillDetail: Bool = false
    
    var body: some View {
        ZStack {
            Button( action: {
                showDrillDetail = true
            }) {
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
                    
                    // Button to select a drill to add in the search drill view
                    if appModel.viewState.showSearchDrills {
                        Button(action: {
                            sessionModel.drillsToAdd(drill: drill)
                        }) {
                            ZStack {
                                
                                if sessionModel.orderedSessionDrills.contains(where: { $0.drill.title == drill.title }) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(appModel.globalSettings.primaryLightGrayColor)
                                        .stroke((appModel.globalSettings.primaryLightGrayColor), lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.white)
                                } else {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(sessionModel.isDrillSelected(drill) ? appModel.globalSettings.primaryYellowColor : Color.clear)
                                        .stroke(sessionModel.isDrillSelected(drill) ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryDarkColor, lineWidth: 2)
                                        .frame(width: 20, height: 20)
                                }
                                
                                
                                if sessionModel.isDrillSelected(drill) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(Color.white)
                                }
                            }
                            
                        }
                        .disabled(sessionModel.orderedSessionDrills.contains(where: { $0.drill.title == drill.title }))
                        
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .sheet(isPresented: $showDrillDetail) {
            DrillDetailView(appModel: appModel,  sessionModel: sessionModel, drill: drill)
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    let mockSesGenModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    // Create a mock drill
        let mockDrill = DrillModel(
            title: "Quick Passing",
            skill: "Passing",
            sets: 3,
            reps: 5,
            duration: 15,
            description: "Short passing drill to improve accuracy",
            tips: ["no funny beezness"],
            equipment: ["ball", "cones"],
            trainingStyle: "Medium Intensity",
            difficulty: "Beginner"
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
