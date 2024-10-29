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
    // questionnaires state variables
    @State private var currentQuestionnaire: Int = 0
    @State private var showQuestionnaireTwo = false
    @State private var showWelcome = false
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    // State variables for animations:
    // animation offset
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    
    //from questionnaire 1
    @State private var selectedPlayer: String = "player"
    @State private var chosenPlayers: [String] = []
    //from questionnaire 2
    @State private var selectedStrength: String = "strength"
    @State private var chosenStrengths: [String] = []
    //from questionnaire 3
    @State private var selectedWeakness: String = "strength"
    @State private var chosenWeaknesses: [String] = []
    
    // var for questionnaire matchedGeometry function
    @Namespace var questionnaireTwoSpace
    @Namespace var questionnaireSpace
    
    
    var body: some View {
        VStack {
            ZStack {
                
                content
                
                
                // ZStack for matchedGeometry for smooth transitions
                ZStack {
                    // Present WelcomeView when showWelcomeView is true
                    if !showQuestionnaireTwo {
                        QuestionnaireTwoView(showQuestionnaireTwo: $showQuestionnaireTwo)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireTwoSpace)
                            .offset(x: UIScreen.main.bounds.width) // out of bounds
                    } else {
                        QuestionnaireTwoView(showQuestionnaireTwo: $showQuestionnaireTwo)// Pass bindings as needed
                            .matchedGeometryEffect(id: "welcome", in: questionnaireTwoSpace)
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
                // animation and text VStack
                // need all these VStacks ???
                VStack {
                    ScrollView {
                        LazyVStack {
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
                // bravo message 0, confined to ZStack
                Text("Nice! I know so much more about you now! Just a few questions to know your style of play.")
                    .foregroundColor(.black)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 400)
                    .opacity(textOpacity0)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 1, confined to ZStack
                Text("Which players do you feel represent your playstyle the best?")
                    .foregroundColor(.black)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity1)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 2, confined to ZStack
                Text("What are your biggest strengths?")
                    .foregroundColor(.black)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity2)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 3, confined to ZStack
                Text("What would you like to work on?")
                    .foregroundColor(.black)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity3)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Back button, confined to ZStack
                HStack {
                    Button(action: {
                        withAnimation {
                            showQuestionnaire = false // Transition to Questionnaire
                        }
                    }) {
                        Image(systemName:"arrow.left")
                            .font(.title2)
                            .foregroundColor(.black)
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
                                showQuestionnaireTwo = true // from Questionnaire to QuestionnaireTwo
                                textOpacity3 = 0.0
                            }
                        }
                    }
                }) {
                    Text("Next")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(Color(hex: "F6C356"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))

                }
                // padding for button
                .padding(.top, 700)
            }
            //ZStack padding
            .padding()
            .background(Color.white)
        }
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
//    }
//}
