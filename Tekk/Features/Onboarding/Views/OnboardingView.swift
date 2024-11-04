//
//  OnboardingView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 9/30/24.//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var navigator: NavigationCoordinator
    @State private var showIntroAnimation = true
    @State private var animationScale: CGFloat = 1.5
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // Main content
            VStack {
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 300, height: 300)
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                
                Text("BravoBall")
                    .foregroundColor(globalSettings.primaryYellowColor)
                    .padding(.bottom, 5)
                    .font(.custom("PottaOne-Regular", size: 45))
                
                Text("Start Small. Dream Big")
                    .foregroundColor(Color(hex:"1E272E"))
                    .padding(.bottom, 100)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Navigation buttons
                Button(action: {
                    navigator.navigate(to: .welcome)
                }) {
                    Text("Create an account")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                
                Button(action: {
                    navigator.navigate(to: .login)
                }) {
                    Text("Login")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(.white)
                        .foregroundColor(globalSettings.primaryYellowColor)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(globalSettings.primaryYellowColor, lineWidth: 2)
                        )
                        .font(.custom("Poppins-Bold", size: 16))
                }
            }
            
            // Intro animation overlay
            if showIntroAnimation {
                RiveViewModel(fileName: "tekk_intro").view()
                    .scaleEffect(animationScale)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) {
                            withAnimation {
                                showIntroAnimation = false
                            }
                        }
                    }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingStateManager())
            .environmentObject(NavigationCoordinator())
    }
}
