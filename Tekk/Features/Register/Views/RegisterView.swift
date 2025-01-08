//
//  RegisterView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/1/25.
//

import Foundation
import SwiftUI
import RiveRuntime

struct RegisterView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    
    
    @State private var currentRegisterStage = 0
    @State private var textOpacity0: Double = 1.0
    @State private var textOpacity1: Double = 1.0
    @State private var riveViewOffset: CGSize = .zero
    
    
    
    @State private var chosenFirstName = ""
    @State private var chosenLastName = ""
    @State private var chosenEmail = ""
    @State private var chosenPassword = ""
    @State private var isSubmitted = false
    @Binding var isLoggedIn: Bool
    @State private var errorMessage = ""
    @State private var authToken = ""
    @State private var showLoadingView = false
    
    var onDetailsSubmitted: () -> Void // Closure to notify when details are submitted

    var body: some View {
        ZStack {
            
            Color.white.edgesIgnoringSafeArea(.all)
            
            if showLoadingView {
                PostOnboardingLoadingView(
                    onboardingData: stateManager.onboardingData,
                    isLoggedIn: $isLoggedIn
                )
                
            } else {
                LazyVStack {
                    Spacer()

                    
                    if currentRegisterStage >= 1 {
                        if currentRegisterStage == 1 {
                            Section(header: Text("Registration Form")) {
                                CustomTextField(
                                    placeholder: "First Name",
                                    icon: "person",
                                    text: $chosenFirstName
                                )
                                .disableAutocorrection(true)
                                
                                CustomTextField(
                                    placeholder: "Last Name",
                                    icon: "person",
                                    text: $chosenLastName
                                )
                                .disableAutocorrection(true)
                                
                                CustomTextField(
                                    placeholder: "Email",
                                    icon: "envelope",
                                    text: $chosenEmail
                                )
                                .keyboardType(.emailAddress)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .padding(.top, 20)
                                
                                
                                CustomTextField(
                                    placeholder: "Password",
                                    icon: "key",
                                    text: $chosenPassword,
                                    isSecure: true
                                )
                                .disableAutocorrection(true)
                            }
                            .font(.custom("Poppins-Bold", size: 16))
                            .padding(.top, 10)
                            
                            
                            if !errorMessage.isEmpty {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                            }
                            
                            Button(action: {
                                submitDetails()
                                showLoadingView = true  // This will trigger the loading screen
                            }) {
                                Text("Submit")
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(isFormValid() ? globalSettings.primaryYellowColor : Color.gray)
                                    .cornerRadius(10)
                            }
                            .disabled(isSubmitted)
                            .padding(.top, 40)
                            .transition(.move(edge: .trailing))
                            .animation(.easeInOut)
                            .offset(x: currentRegisterStage == 1 ? 0 : UIScreen.main.bounds.width)
                            
                            //                // "Already have an account?" section
                            //                Section {
                            //                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken), showLoginPage: .constant(false)) {
                            //                        Text("Already have an account? Log in here")
                            //                            .foregroundColor(.blue)
                            //                    }
                            //                }
                            
                        }
                    }
                }
                .padding(.top, 220)

                
                Spacer()
                
                // Bravo Animation
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: 250, height: 250)
                    .padding(.bottom, 5)
                    .offset(x: riveViewOffset.width, y: riveViewOffset.height)
                    .animation(.easeInOut(duration: 0.5), value: riveViewOffset)
                
                if currentRegisterStage == 0 {
                    Text("Finally, let's create an account for you!")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding(.horizontal, 80)
                        .padding(.bottom, 400)
                        .font(.custom("Poppins-Bold", size: 16))
                        .opacity(textOpacity0)
                    
                    // Next Button
                    Button(action: handleNextButton) {
                        Text("Next")
                            .frame(width: 325, height: 15)
                            .padding()
                            .background(globalSettings.primaryYellowColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    .padding(.top, 700)
                    
                } else if currentRegisterStage == 1 {
                    Text("Fill out your personal info below!")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .padding(.bottom, 500)
                        .padding(.leading, 150)
                        .font(.custom("Poppins-Bold", size: 16))
                        .opacity(textOpacity1)
                }
                
            }
        }
        .padding()
        .background(.white)
        .edgesIgnoringSafeArea(.all)
    }
        
    
    // TODO: add more constraints for secure registration
    
    // bool since this is a t/f type value
    private func isFormValid() -> Bool {
        return chosenFirstName.count > 1 &&
               chosenLastName.count > 1 &&
               chosenEmail.count > 3 &&
               chosenPassword.count > 5
    }
        
    func submitDetails() {
        // Validate form
        guard isFormValid() else {
            errorMessage = "Please fill in all fields"
            return
        }
        
        // Update state manager
        stateManager.updateRegister(
            firstName: chosenFirstName,
            lastName: chosenLastName,
            email: chosenEmail,
            password: chosenPassword
        )
        
        // other states
        isSubmitted = true
        errorMessage = ""
        onDetailsSubmitted()
    }


    private func handleNextButton() {
        if currentRegisterStage == 0 {
            withAnimation(.spring()) {
                riveViewOffset = CGSize(width: -75, height: -250)
                currentRegisterStage = 1
                textOpacity0 = 0.0
            }
        }
    }
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isLoggedIn: .constant(false), onDetailsSubmitted: {})
    }
}
