//
//  MainTabView.swift
//  BravoBall
//
//  Created by Jordan on 11/2/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct MainTabView: View {
    @EnvironmentObject var navigator: NavigationCoordinator
    let authToken: String
    
    var body: some View {
        TabView {
            // Your tab items here
            HomeProgramView()
                .tabItem {
                    Image(systemName: "figure.run")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }
        .onAppear {
            // Handle any initialization needed with authToken
            print("MainTabView appeared with token: \(authToken)")
        }
    }
}

// MARK: - Preview
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView(authToken: "preview-token")
            .environmentObject(NavigationCoordinator())
    }
}
