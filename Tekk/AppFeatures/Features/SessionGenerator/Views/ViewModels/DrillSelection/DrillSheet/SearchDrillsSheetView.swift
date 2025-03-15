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




#Preview {
    // Create mock data and models
    let mockAppModel = MainAppModel()
    let mockSessionModel = SessionGeneratorModel(appModel: MainAppModel(), onboardingData: OnboardingModel.OnboardingData())
    
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
