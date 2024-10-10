//
//  QuestionnaireTwo.swift
//  Tekk
//
//  Created by Joshua Conklin on 10/8/24.
//
import SwiftUI
import RiveRuntime

struct QuestionnaireTwoView: View {
    @Binding var showQuestionnaireTwo: Bool
    // questionnaires state variables
    @State private var currentQuestionnaireTwo: Int = 0
    @State private var showQuestionnaire = false // need ?
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 0.0
    @State private var textOpacity2: Double = 0.0
    @State private var textOpacity3: Double = 0.0
    @State private var textOpacity4: Double = 0.0
    @State private var textOpacity5: Double = 0.0
    // State variables for animations:
    // animation offset
    @State private var riveViewOffset: CGSize = .zero // Offset for Rive animation hello
    //from questionnaire 1
    @State private var selectedYesNoTeam: String = "yesNo"
    @State private var chosenYesNoTeam: [String] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
//                    VStack {
                        // Current questionnaire REPRESENTATION based on the state variable
                    if currentQuestionnaireTwo == 1 {
                        QuestionnaireTwo_1(currentQuestionnaireTwo: $currentQuestionnaireTwo, selectedYesNoTeam: $selectedYesNoTeam, chosenYesNoTeam: $chosenYesNoTeam)
                            .transition(.move(edge: .trailing)) // Move in from the right
                            .animation(.easeInOut) // Animate the transition
                            .offset(x: currentQuestionnaireTwo == 1 ? 0 : UIScreen.main.bounds.width) // Start off-screen
                    }
//                    }
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
                Text("This is going so well! Now I just need to specialize the plan to your needs.")
                    .foregroundColor(.white)
                    .padding(.horizontal, 80)
                    .padding(.bottom, 400)
                    .opacity(textOpacity0)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 1, confined to ZStack
                Text("Are you currently playing for a team?") // LATER: make it mention in-season or off-season if clicked yes
                    .foregroundColor(.white)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity1)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 2, confined to ZStack
                Text("What is your primary goal?")
                    .foregroundColor(.white)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity2)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 3, confined to ZStack
                Text("When are you looking to achieve this by?")
                    .foregroundColor(.white)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity3)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 4, confined to ZStack
                Text("Pick your training level.")
                    .foregroundColor(.white)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity4)
                    .font(.custom("Poppins-Bold", size: 16))
                // bravo message 5, confined to ZStack
                Text("What days would you like to train?")
                    .foregroundColor(.white)
                    .padding() // padding for text edges
                    .padding(.bottom, 500)
                    .padding(.leading, 150)
                    .opacity(textOpacity5)
                    .font(.custom("Poppins-Bold", size: 16))
                
                // Back button, confined to ZStack
                HStack {
                    Button(action: {
                        withAnimation {
                            showQuestionnaireTwo = false // Transition to Questionnaire
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
                        currentQuestionnaireTwo = 1
                        textOpacity0 = 0.0
                        textOpacity1 = 1.0
                    }
//
//                    // If statements to Move to the next questionnaire
//                    if currentQuestionnaireTwo == 1 {
//                        if validateQTwo1() {
//                            withAnimation {
//                                currentQuestionnaireTwo = 2
//                                textOpacity1 = 0.0
//                                textOpacity2 = 1.0
//                            }
//                        }
//                    }
                }) {
                    Text("Next")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(Color(hex: "947F63"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))

                }
                // padding for button
                .padding(.top, 700)
            }
            //ZStack padding
            .padding()
            .background(Color(hex:"1E272E"))
        }
    }
}


// MARK: - Preview

//struct QuestionnaireTwo_Previews: PreviewProvider {
//    @State static var showQuestionnaireTwo = true // Example binding variable
//
//    static var previews: some View {
//        QuestionnaireTwoView(showQuestionnaireTwo: $showQuestionnaireTwo)
//            .preferredColorScheme(.dark) // Optional: Set the color scheme for the preview
//    }
//}
