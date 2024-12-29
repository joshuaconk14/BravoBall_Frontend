//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//  This file contains the main view of the app.

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject private var stateManager = OnboardingStateManager()
    @State private var isLoggedIn: Bool = false
    @State private var authToken: String = ""
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        if isLoggedIn {
            MainTabView(authToken: $authToken)
        } else {
            OnboardingView(
                isLoggedIn: $isLoggedIn,
                authToken: $authToken,
                showOnboarding: $showOnboarding
            )
            .environmentObject(stateManager)
//    
//            SimplifiedOnboardingView()
//            TestOnboardingView()
        }
    }
}

// for font ?
//init() {
//    for familyName in UIFont.familyNames {
//        print(familyName)
//        
//        for fontName in UIFont.fontNames(forFamilyName: familyName) {
//            print(fontName)
//        }
//    }
//}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro")
    }
}
