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
        DrillSearchView(
            appModel: appModel,
            sessionModel: sessionModel,
            onDrillsSelected: { selectedDrills in
                // Add the selected drills to the session
                sessionModel.addDrillToSession(drills: selectedDrills)
                
                // Close the sheet
                appModel.viewState.showSearchDrills = false
                
                // Call the dismiss callback
                dismiss()
            },
            title: "Search Drills",
            actionButtonText: { count in
                "Add \(count) \(count == 1 ? "Drill" : "Drills") to Session"
            },
            filterDrills: { drill in
                sessionModel.orderedSessionDrills.contains(where: { $0.drill.id == drill.id })
            },
            isDrillSelected: { drill in
                sessionModel.isDrillSelected(drill)
            },
            dismiss: dismiss
        )
        .onAppear {
            print("🔍 SearchDrillsSheetView appeared")
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
