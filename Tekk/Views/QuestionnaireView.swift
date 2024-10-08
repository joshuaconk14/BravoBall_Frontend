//
//  QuestionnaireView.swift
//  Tekk
//
//  Created by Josh on 8/26/24.
//  This file contains the QuestionnaireView, which is used to show the questionnaire to the user.

import SwiftUI
import RiveRuntime

// MARK: - Main body
struct QuestionnaireView: View {
    @Binding var showQuestionnaire: Bool
    @State private var showWelcome = false
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    // State variables for animations:
    // animation offset
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    // questionnaires state variables
    @State private var currentQuestionnaire: Int = 0
    
    //from questionnaire 1
    @State private var selectedPlayer: String = "player"
    @State private var chosenPlayers: [String] = []
    //from questionnaire 2
    @State private var selectedStrength: String = "strength"
    @State private var chosenStrengths: [String] = []
    //from questionnaire 3
    @State private var selectedWeakness: String = "strength"
    @State private var chosenWeaknesses: [String] = []
    
    
    var body: some View {
        NavigationView {
            // ZStack so lets get tekky button and back button arent confined to VStack
            ZStack {
                // animation and text VStack
                VStack {
                    ScrollView {
                        VStack {
                            // Current questionnaire REPRESENTATION based on the state variable
                            if currentQuestionnaire == 1 {
                                Questionnaire_1(currentQuestionnaire: $currentQuestionnaire, selectedPlayer: $selectedPlayer, chosenPlayers: $chosenPlayers)
                                    .transition(.move(edge: .trailing)) // Move in from the right
                                    .animation(.easeInOut) // Animate the transition
                                    .offset(x: currentQuestionnaire == 1 ? 0 : UIScreen.main.bounds.width) // Start off-screen
                            } else if currentQuestionnaire == 2 {
                                Questionnaire_2(currentQuestionnaire: $currentQuestionnaire, selectedStrength: $selectedStrength, chosenStrengths: $chosenStrengths)
                                    .transition(.move(edge: .trailing)) // Move in from the right
                                    .animation(.easeInOut) // Animate the transition
                                    .offset(x: currentQuestionnaire == 2 ? 0 : UIScreen.main.bounds.width) // Start off-screen
                            } else if currentQuestionnaire == 3 {
                                Questionnaire_3(currentQuestionnaire: $currentQuestionnaire, selectedWeakness: $selectedWeakness, chosenWeaknesses: $chosenWeaknesses)
                                    .transition(.move(edge: .trailing)) // Move in from the right
                                    .animation(.easeInOut) // Animate the transition
                                    .offset(x: currentQuestionnaire == 3 ? 0 : UIScreen.main.bounds.width) // Start off-screen
                            }
                        }
                    }
                    .frame(height: 410) // Set the height of the ScrollView to limit visible area
                    .padding(.top, 200) // Optional: Add some padding at the bottom
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
                // bravo message 3, confined to ZStack
                Text("Great! I know so much more about you now! Just a few questions and we can create your plan.")
                    .foregroundColor(.white)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 400)
                    .opacity(textOpacity0)
                // bravo message 3, confined to ZStack
                Text("Which players do you feel represent your playstyle the best?")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity1)
                // bravo message 3, confined to ZStack
                Text("What are your biggest strengths?")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity2)
                // bravo message 4, confined to ZStack
                Text("What would you like to work on?")
                    .foregroundColor(.white)
                    .padding()
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity3)
                
                // Back button, confined to ZStack
                HStack {
                    Button(action: {
                        withAnimation {
                            showQuestionnaire = false // Transition to Questionnaire
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
                        currentQuestionnaire = 1
                        textOpacity0 = 0.0
                        textOpacity1 = 1.0
                    }

                    // If statements to Move to the next questionnaire
                    if currentQuestionnaire == 1 {
                        if validateQ1() {
                            withAnimation {
                                currentQuestionnaire = 2
                                textOpacity1 = 0.0
                                textOpacity2 = 1.0
                            }
                        }
                    }
                    if currentQuestionnaire == 2 {
                        if validateQ2() {
                            withAnimation {
                                currentQuestionnaire = 3
                                textOpacity2 = 0.0
                                textOpacity3 = 1.0
                            }
                        }
                    }
                    if currentQuestionnaire == 3 {
                        if validateQ3() {
                            withAnimation {
                                currentQuestionnaire = 4
                                textOpacity3 = 0.0
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
                }
                .padding(.top, 700)
            }
            //VStack padding
            .padding()
            .background(Color(hex:"1E272E"))
        }
        // Zstack padding
        .padding()
        .background(Color(hex:"1E272E"))
    }
    
    // MARK: - Validation functions
    // Validation function for Questionnaire 2 (need?)
    private func validateQ1() -> Bool {
        return !chosenPlayers.isEmpty // at least 1 player is chosen
    }
    // Validation function for Questionnaire 3 (need?)
    private func validateQ2() -> Bool {
        return !chosenStrengths.isEmpty // at least 1 player is chosen
    }
    // Validation function for Questionnaire 3 (need?)
    private func validateQ3() -> Bool {
        return !chosenWeaknesses.isEmpty // at least 1 player is chosen
    }
}


    
    


// MARK: - Preview

//struct Questionnaire_Previews: PreviewProvider {
//    @State static var showQuestionnaire = true // Example binding variable
//
//    static var previews: some View {
//        QuestionnaireView(showQuestionnaire: $showQuestionnaire)
//            .preferredColorScheme(.dark) // Optional: Set the color scheme for the preview
//    }
//}
