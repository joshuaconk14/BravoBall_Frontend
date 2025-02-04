//
//  SearchDrillsSheetView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/3/25.
//

import SwiftUI


struct SearchDrillsSheetView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    @State private var selectedTab: searchDrillsTab = .all
    
    enum searchDrillsTab {
        case all, byType, groups
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Search Drills")
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
            
            // Tab buttons
            HStack(spacing: 20) {
                TabButton(title: "All", isSelected: selectedTab == .all) {
                    selectedTab = .all
                }
                
                TabButton(title: "By Type", isSelected: selectedTab == .byType) {
                    selectedTab = .byType
                }
                
                TabButton(title: "Groups", isSelected: selectedTab == .groups) {
                    selectedTab = .groups
                }
            }
            .padding(.horizontal)
            
            switch selectedTab {
            case .all:
                AllDrillsView(appModel: appModel, sessionModel: sessionModel)
            case .byType:
                ByTypeView(appModel: appModel, sessionModel: sessionModel)
            case .groups:
                GroupsView(appModel: appModel, sessionModel: sessionModel)
            }

        }
    }
}

// MARK: Tab Button
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 14))
                .foregroundColor(isSelected ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.yellow : Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.yellow : Color.gray, lineWidth: 1)
                )
        }
    }
}

//MARK: AllDrillsView
struct AllDrillsView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var searchText: String = ""
    
    var body: some View {
        VStack {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search drills...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
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
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding()
            
            // Drills list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredDrills) { drill in
                        DrillRow(appModel: appModel, sessionModel: sessionModel,
                            drill: drill
                        )
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
    }
    
    // Filtered drills based on search text
    var filteredDrills: [DrillModel] {
        if searchText.isEmpty {
            return SessionGeneratorModel.testDrills
        } else {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.title.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

//MARK: ByTypeView
struct ByTypeView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var selectedButton: skillType = .none
    
    enum skillType {
        case passing
        case dribbling
        case shooting
        case firstTouch
        case crossing
        case defending
        case goalkeeping
        case none
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                Text("Skill")
                    .padding()
                VStack(spacing: 10) {
                        SelectionButton(title: "Passing", isSelected: selectedButton == .passing) {
                            selectedButton = .passing
                        }
                        SelectionButton(title: "Dribbling", isSelected: selectedButton == .dribbling) {
                            selectedButton = .dribbling
                        }
                        SelectionButton(title: "Shooting", isSelected: selectedButton == .shooting) {
                            selectedButton = .shooting
                        }
                        SelectionButton(title: "First Touch", isSelected: selectedButton == .firstTouch) {
                            selectedButton = .firstTouch
                        }
                        SelectionButton(title: "Crossing", isSelected: selectedButton == .crossing) {
                            selectedButton = .crossing
                        }
                        SelectionButton(title: "Defending", isSelected: selectedButton == .defending) {
                            selectedButton = .defending
                        }
                        SelectionButton(title: "Goalkeeping", isSelected: selectedButton == .goalkeeping) {
                            selectedButton = .goalkeeping
                        }
                    }
                    Spacer()
            }
            .padding(.top, 30)
            
            switch selectedButton {
            case .passing:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Passing", dismiss: {selectedButton = .none})
            case .dribbling:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Dribbling", dismiss: {selectedButton = .none})
            case .shooting:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Shooting", dismiss: {selectedButton = .none})
            case .firstTouch:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "First Touch", dismiss: {selectedButton = .none})
            case .crossing:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Crossing", dismiss: {selectedButton = .none})
            case .defending:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Defending", dismiss: {selectedButton = .none})
            case .goalkeeping:
                SpecificDrillsView(appModel: appModel, sessionModel: sessionModel, skillType: "Goalkeeping", dismiss: {selectedButton = .none})
            case .none:
                EmptyView()
            }
        }
    }
}

// MARK: Specific Drills View
struct SpecificDrillsView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let skillType: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                        Text("Back")  // Optional: include text
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .padding()
                }
                Spacer()
            }
            
            // Drills list
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(specificDrills) { drill in
                        DrillRow(appModel: appModel, sessionModel: sessionModel,
                            drill: drill
                        )
                        .padding(.horizontal)
                        Divider()
                    }
                }
            }
        }
        .background(Color.white)
    }
    var specificDrills: [DrillModel] {
        return SessionGeneratorModel.testDrills.filter { drill in
            drill.type.lowercased().contains(skillType.lowercased())
        }
    }
}

// MARK: Selection Button
struct SelectionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 18))
                .foregroundColor(.gray)
                .padding(.horizontal)
                .frame(width: 200)
                .padding(.vertical, 12)
                .background(Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}


//MARK: GroupsView
struct GroupsView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var selectedGroup: GroupModel? = nil
    
    var body: some View {
        ZStack {
            AllGroupsDisplay(appModel: appModel, sessionModel: sessionModel, selectedGroup: $selectedGroup)
            Spacer()
        }
        .sheet(item: $selectedGroup) { group in
            GroupDetailView(appModel: appModel, sessionModel: sessionModel, group: group)
        }
    }
    
}

#Preview {
    // Create mock data and models
    let mockAppModel = MainAppModel()
    let mockSessionModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    // Create some test drills
    let testDrills = [
        DrillModel(
            title: "Passing Drill",
            type: "Passing",
            sets: "3",
            reps: "10",
            duration: "15 min",
            description: "Basic passing drill for beginners",
            tips: ["Keep your head up", "Follow through"],
            equipment: ["Ball", "Cones"]
        ),
        DrillModel(
            title: "Shooting Practice",
            type: "Shooting",
            sets: "4",
            reps: "8",
            duration: "20 min",
            description: "Advanced shooting drill",
            tips: ["Plant foot properly", "Strike with laces"],
            equipment: ["Ball", "Goal"]
        ),
        DrillModel(
            title: "Dribbling Skills",
            type: "Dribbling",
            sets: "5",
            reps: "6",
            duration: "25 min",
            description: "Intermediate dribbling exercises",
            tips: ["Close control", "Use both feet"],
            equipment: ["Ball", "Cones"]
        )
    ]
    
    // Create some test groups
    let testGroups = [
        GroupModel(
            name: "Beginner Drills",
            description: "Basic training drills",
            drills: [testDrills[0]]
        ),
        GroupModel(
            name: "Advanced Training",
            description: "Complex drills",
            drills: [testDrills[1], testDrills[2]]
        )
    ]
    
    // Add test data to session model
    mockSessionModel.savedDrills = testGroups
    
    return SearchDrillsSheetView(
        appModel: mockAppModel,
        sessionModel: mockSessionModel,
        dismiss: {}
    )
}
