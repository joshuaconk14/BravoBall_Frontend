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
    @Binding var showOnboarding: Bool
    // var for "welcome" matchedGeometry function
    @Namespace var welcomeSpace
    // var for private showIntroAnimation scale (so it doesn't affect other elements
    @State private var animationScale: CGFloat = 1.5
    
    var body: some View {
        VStack {
            ZStack {
                
                content
                
                
                // ZStack for matchedGeometry for smooth page transitions
                ZStack {
                    if !showLoginPage {
                        LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken, showLoginPage: $showLoginPage)
                            .matchedGeometryEffect(id: "login", in: welcomeSpace)
                            .offset(y: UIScreen.main.bounds.height)
                    } else {
                        LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken, showLoginPage: $showLoginPage)
                            .matchedGeometryEffect(id: "login", in: welcomeSpace)
                            .offset(y: 0)
                    }
                }
                
                // ZStack for matchedGeometry for smooth transitions
                ZStack {
                    // Present WelcomeView when showWelcomeView is true
                    if !showWelcome {
                        WelcomeView(showWelcome: $showWelcome)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: welcomeSpace)
                            .offset(x: UIScreen.main.bounds.width) // out of bounds
    //                    OnboardingView(isLoggedIn: $isLoggedIn, authToken: $authToken, showOnboarding: $showOnboarding)
    //                        .matchedGeometryEffect(id: "onboarding", in: namespace)
    //                        .offset(x: 0) // showing
                    } else {
                        WelcomeView(showWelcome: $showWelcome)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: welcomeSpace)
                            .offset(x: 0) // showing
    //                    OnboardingView(isLoggedIn: $isLoggedIn, authToken: $authToken, showOnboarding: $showOnboarding)
    //                        .matchedGeometryEffect(id: "onboarding", in: namespace)
    //                        .offset(x: UIScreen.main.bounds.width) // out of bounds
                    }
                }
                // Intro animation, in front due to ZStack
                //  the animation ending works because of if statement declaring showIntroAnimation function
                if showIntroAnimation {
                    RiveViewModel(fileName: "tekk_intro").view()
                        .scaleEffect(animationScale)
                        .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(false) // no user interaction during this animation
                    // Start a timer to hide the intro animation after a certain duration
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) { // seconds until its false
                                showIntroAnimation = false
                            }
                        }
                }
            }
        }
    }
    var content: some View {
        VStack {
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 300, height: 300)
                .padding(.top, 30)
                .padding(.bottom, 10)
            Text("BravoTekk")
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .font(.custom("PottaOne-Regular", size: 45))
            
            Text("Start Small. Dream Big")
                .foregroundColor(.white)
                .padding(.bottom, 100)
                .font(.custom("Poppins-Bold", size: 16))
            
            // transition to WelcomeView
            Button(action: {
                withAnimation(.spring()) {
                    showWelcome.toggle()
                }
            }) {
                Text("Let's get tekky")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(Color(hex: "947F63"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            // lets get tekky button padding to move it down
            .padding(.horizontal)
            .padding(.top, 80)
            
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
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            
            Spacer()
            
        }
        .padding()
        .background(Color(hex:"1E272E"))
    }
}


// Preview canvas

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Provide constant bindings w/ diff views for the preview
//        OnboardingView(isLoggedIn: .constant(false), authToken: .constant(""), showOnboarding: .constant(true))
//    }
//}
