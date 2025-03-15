//
//  GroupsView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//

import SwiftUI

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
