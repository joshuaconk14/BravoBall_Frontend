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
