//
//  OnboardingView.swift
//  Tekk
//
//  Created by Joshua Conklin on 9/30/24.
//

import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @Binding var isLoggedIn: Bool
    @Binding var authToken: String
    @State private var showLoginPage = false // State to control login page visibility
    @State private var showWelcome = false
    @State private var showIntroAnimation = true
    
    var body: some View {
        ZStack {
            
            content
            
            if showLoginPage {
                LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken, showLoginPage: $showLoginPage)
                    .transition(.move(edge: .bottom))
                    .animation(.easeInOut)
            }
            // Present WelcomeView when showWelcomeView is true
            if showWelcome {
                WelcomeView(showWelcome: $showWelcome)// Pass bindings as needed
                    .transition(.move(edge: .trailing))
                    .animation(.easeInOut)
            }
        }
//      this works because of if statement declaring showIntroAnimation function
//      Start a timer to hide the intro animation after a certain duration
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) { // seconds until its false
                showIntroAnimation = false
            }
        }
    }
    var content: some View {
        // add NavigationView?
        ZStack {
            VStack {
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 300, height: 300)
                    .padding(.top, 150)
                    .padding(.bottom, 10)
                Text("BravoTekk")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
                Text("Start Small. Dream Big")
                    .foregroundColor(.white)
                    .padding(.bottom, 100)
                
                // transition to WelcomeView
                Button(action: {
                    withAnimation(.spring()) {
                        showWelcome = true
                    }
                }) {
                    Text("Let's get tekky")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(Color(hex: "947F63"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                // transition to login page
                Button(action: {
                    withAnimation(.spring()) {
                        showLoginPage = true
                    }
                }) {
                    Text("Login")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(.gray.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
                
                Spacer()
                
            }
//          Intro animation, in front in ZStack
            if showIntroAnimation {
                RiveViewModel(fileName: "tekk_intro").view()
                    .frame(width: 600, height: 1200)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false) // no user interaction during this animation
            }

        }
        .padding()
        .background(Color(hex:"1E272E"))
    }
}


// Preview canvas

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide constant bindings w/ diff views for the preview
//        OnboardingView(isLoggedIn: .constant(false), authToken: .constant(""))
//    }
//}
