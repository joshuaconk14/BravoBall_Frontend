//
// WelcomeView.swift
//  Tekk
//
//  Created by Josh on 9/28/24.
//  This file contains the LoginView, which is used to welcome the user.

import SwiftUI
import RiveRuntime

struct WelcomeView: View {
    // Note: Binding/ Bool binds this structure, state private func on other pages determines function of this structure
    @Binding var showWelcome: Bool
    @State private var showOnboarding = false
    @State private var showQuestionnaire = false
//    @State private var showQuestionnaire = false
    @State private var textOpacity1: Double = 1.0
    @State private var textOpacity2: Double = 0.0
    // welcomeInput is where bravo is asking for player details, this is what will show when next button on hello bravo page is clicked
    @State private var welcomeInput: Int = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedAge: String = "Select your Age"
    @State private var selectedLevel: String = "Select your Level"
    @State private var selectedPosition: String = "Select your Position"
    
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    // var for matchedGeometry function
    @Namespace var questionnaireSpace
    
    
    var body: some View {
        VStack {
            ZStack {
                
                content
                
                // ZStack for matchedGeometry for smooth transitions
                ZStack {
                    // Present WelcomeView when showWelcomeView is true
                    if !showQuestionnaire {
                        QuestionnaireView(showQuestionnaire: $showQuestionnaire)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireSpace)
                            .offset(x: UIScreen.main.bounds.width) // out of bounds
                    } else {
                        QuestionnaireView(showQuestionnaire: $showQuestionnaire)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireSpace)
                            .offset(x: 0) // showing
                    }
                }
            }
        }
    }
    
    var content: some View {
        NavigationView {
            // ZStack so lets get tekky button and back button arent confined to VStack
            ZStack {
                VStack {
                    if welcomeInput == 1 {
                        welcomeQs(welcomeInput: $welcomeInput, firstName: $firstName, lastName: $lastName, selectedAge: $selectedAge, selectedLevel: $selectedLevel, selectedPosition: $selectedPosition)
                            .transition(.move(edge: .trailing)) // transition from right
                            .animation(.easeInOut) // Animate the transition
                            .offset(x: welcomeInput == 1 ? 0 : UIScreen.main.bounds.width)
                    }
                }
                Spacer()
                // panting animation
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 5)
                // riveViewOffset is amount it will offset, button will trigger it
                    .offset(x: riveViewOffset.width, y: riveViewOffset.height)
                    .animation(.easeInOut(duration: 0.5), value: riveViewOffset)
                //MARK: - Bravo messages
                // bravo message 1, confined to ZStack
                Text("Hello there, I'm Bravo! Let's help you become a more tekky player.")
                    .foregroundColor(.white)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 400)
                    .opacity(textOpacity1)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 2, confined to ZStack
                Text("Enter your player details below")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity2)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Back button, confined to ZStack
                HStack {
                    Button(action: {
                        withAnimation {
                            showWelcome = false // Transition to OnboardingView
                        }
                    }) {
                        Image(systemName:"arrow.left")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                    .padding(.bottom, 725)
                    
                    Spacer() // moving back button to left
                }
                
                // MARK: - "Next" button
                // Current questionnaire ACTION based on the state variable
                Button(action: {
                    withAnimation(.spring()) {
                        // Move the Rive animation up and show list
                        riveViewOffset = CGSize(width: -75, height: -250)
                        welcomeInput = 1
                        textOpacity1 = 0.0
                        textOpacity2 = 1.0
                    }
                    // Move to the questionnaire
                    if welcomeInput == 1 {
                        if validateQ1() {
                            withAnimation {
                                showQuestionnaire.toggle() // from welcome to questionnaire
                                textOpacity2 = 0.0
                            }
                        }
                    }
                }) {
                    Text("Next")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(Color(hex: "947F63"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                .padding(.top, 700)
            }
            //VStack padding
            .padding()
            .background(Color(hex:"1E272E"))
        }
    }
    // MARK: - (change to || for quick nav and && when done)
    // Validation function for Questionnaire 1
    private func validateQ1() -> Bool {
       return !firstName.isEmpty || !lastName.isEmpty || selectedAge != "Select your Age" || selectedLevel != "Select your Level" || selectedPosition != "Select your Position"
    }
}


// MARK: - Preview
//struct WelcomeView_Previews: PreviewProvider {
//    @State static var showWelcome = true // Example binding variable
//
//    static var previews: some View {
//        WelcomeView(showWelcome: $showWelcome)
//            .preferredColorScheme(.dark) // Optional: Set the color scheme for the preview
//    }
//}
