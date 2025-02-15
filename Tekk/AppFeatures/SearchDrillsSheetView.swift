//
//  SearchDrillsSheetView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/3/25.
//

import SwiftUI


struct SearchDrillsSheetView: View {
    @ObservedObject var appModel: MainAppModel
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
        .safeAreaInset(edge: .bottom) {
            if sessionModel.selectedDrills.count > 0 {
                Button(action: {
                    sessionModel.addDrillToSession(drills: sessionModel.selectedDrills)
                    appModel.viewState.showSearchDrills = false
                }) {
                    Text(sessionModel.selectedDrills.count == 1 ? "Add \(sessionModel.selectedDrills.count) Drill" : "Add \(sessionModel.selectedDrills.count) Drills")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .padding()
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
    @ObservedObject var appModel: MainAppModel
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
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
            )
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
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel

    
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 15) {
                    Text("Skill")
                        .padding()
                    VStack(spacing: 10) {
                        ForEach(MainAppModel.SkillType.allCases, id: \.self) { skill in
                            SelectionButton(
                                title: skill.rawValue,
                                isSelected: appModel.selectedSkill == skill
                            ){
                                appModel.selectedSkill = skill
                            }
                        }
                        
                    }
                    Spacer()
                    
                    Text("Training Style")
                        .padding()
                    VStack(spacing: 10) {
                        ForEach(MainAppModel.TrainingStyleType.allCases, id: \.self) { trainingStyle in
                            SelectionButton(
                                title: ("\(trainingStyle.rawValue) Intensity"),
                                isSelected: appModel.selectedTrainingStyle == trainingStyle
                            ){
                                appModel.selectedTrainingStyle = trainingStyle
                            }
                        }
                        
                    }
                    
                    Spacer()
                    
                    Text("Difficulty")
                        .padding()
                    VStack(spacing: 10) {
                        ForEach(MainAppModel.DifficultyType.allCases, id: \.self) { difficulty in
                            SelectionButton(
                                title: difficulty.rawValue,
                                isSelected: appModel.selectedDifficulty == difficulty
                            ){
                                appModel.selectedDifficulty = difficulty
                            }
                        }
                        
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .frame(maxWidth: .infinity)
            }
            
            
            if let selectedSkill = appModel.selectedSkill {
                SpecificDrillsView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    type: selectedSkill.rawValue,
                    dismiss: {appModel.selectedSkill = nil})
            }
            
            if let selectedTrainingStyle = appModel.selectedTrainingStyle {
                SpecificDrillsView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    type: selectedTrainingStyle.rawValue,
                    dismiss: {appModel.selectedTrainingStyle = nil})
            }
            
            if let selectedDifficulty = appModel.selectedDifficulty {
                SpecificDrillsView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    type: selectedDifficulty.rawValue,
                    dismiss: {appModel.selectedDifficulty = nil})
            }

        }
    }
}

// MARK: Specific Drills View
struct SpecificDrillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let type: String
    let dismiss: () -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                            Text("Back")
                                .font(.custom("Poppins-Bold", size: 16))
                        }
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .padding()
                    }
                    
                    Text(appModel.selectedTrainingStyle != nil ? ("\(type) Intensity") : type)
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding(.leading, 70)
                    
                    
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
        }
        .background(Color.white)
    }
    
    // Returning drills based on type selected
    var specificDrills: [DrillModel] {
        if appModel.selectedSkill != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.skill.lowercased().contains(type.lowercased())
            }
        } else if appModel.selectedTrainingStyle != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.trainingStyle.lowercased().contains(type.lowercased())
            }
        }
        if appModel.selectedDifficulty != nil {
            return SessionGeneratorModel.testDrills.filter { drill in
                drill.difficulty.lowercased().contains(type.lowercased())
            }
        } else {
            return []
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
    @ObservedObject var appModel: MainAppModel
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
            skill: "Passing",
            sets: 3,
            reps: 10,
            duration: 15,
            description: "Basic passing drill for beginners",
            tips: ["Keep your head up", "Follow through"],
            equipment: ["Ball", "Cones"],
            trainingStyle: "Medium Intensity",
            difficulty: "Beginner"
        ),
        DrillModel(
            title: "Shooting Practice",
            skill: "Shooting",
            sets: 4,
            reps: 8,
            duration: 20,
            description: "Advanced shooting drill",
            tips: ["Plant foot properly", "Strike with laces"],
            equipment: ["Ball", "Goal"],
            trainingStyle: "Medium Intensity",
            difficulty: "Beginner"
        ),
        DrillModel(
            title: "Dribbling Skills",
            skill: "Dribbling",
            sets: 5,
            reps: 6,
            duration: 25,
            description: "Intermediate dribbling exercises",
            tips: ["Close control", "Use both feet"],
            equipment: ["Ball", "Cones"],
            trainingStyle: "High Intensity",
            difficulty: "Intermediate"
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
