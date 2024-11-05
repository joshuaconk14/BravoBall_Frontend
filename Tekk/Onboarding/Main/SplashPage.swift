//
//  SplashPage.swift
//  BravoBall
//
//  Created by Jordan on 11/5/24.
//

import Foundation
import SwiftUI
import RiveRuntime

struct SplashView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var pageCoordinator: PageCoordinator
    @EnvironmentObject var bravoCoordinator: BravoCoordinator
    @State private var animationScale: CGFloat = 1.5
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack {
                // Bravo Animation
                BravoView()
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                
                // Title
                Text("BravoBall")
                    .foregroundColor(globalSettings.primaryYellowColor)
                    .padding(.bottom, 5)
                    .font(.custom("PottaOne-Regular", size: 45))
                
                // Subtitle
                Text("Start Small. Dream Big")
                    .foregroundColor(Color(hex:"1E272E"))
                    .padding(.bottom, 100)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Get Started Button
                Button(action: handleGetStarted) {
                    Text("Get Started")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            setupInitialState()
        }
    }
    
    private func setupInitialState() {
        bravoCoordinator.centerBravo()
        bravoCoordinator.showMessage("Hello there, I'm Bravo! Let's help you become a more tekky player.", duration: 0)
    }
    
    private func handleGetStarted() {
        bravoCoordinator.moveToSide()
        pageCoordinator.moveToNext()
    }
}

#Preview {
    SplashView()
        .environmentObject(PageCoordinator())
        .environmentObject(BravoCoordinator())
}
