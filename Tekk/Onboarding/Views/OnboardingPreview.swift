//
//  OnboardingPreview.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI

struct OnboardingPreview: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

//// Sample View to present the onboarding
//struct ContentView: View {
//    @State private var showOnboarding = true
//    
//    var body: some View {
//        VStack {
//            if !showOnboarding {
//                Text("Main App Content")
//                    .font(.title)
//                
//                Button("Show Onboarding Again") {
//                    showOnboarding = true
//                }
//            }
//        }
//        .sheet(isPresented: $showOnboarding) {
//            OnboardingView()
//        }
//    }
//}
