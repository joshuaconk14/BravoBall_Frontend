//
//  RegisterView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/1/25.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
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
        NavigationView {
            Form {
                Section(header: Text("Player Information")) {
                    TextField("First Name", text: $chosenFirstName)
                        .disableAutocorrection(true)
                    TextField("Last Name", text: $chosenLastName)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $chosenEmail)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Password", text: $chosenPassword)
                        .disableAutocorrection(true)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    submitDetails()
                    showLoadingView = true  // This will trigger the fullScreenCover
                }) {
                    Text("Submit")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid() ? globalSettings.primaryYellowColor : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(isSubmitted)
                .fullScreenCover(isPresented: $showLoadingView) {
                    PostOnboardingLoadingView(
                        onboardingData: stateManager.onboardingData,
                        isLoggedIn: $isLoggedIn
                    )
                }

//                // "Already have an account?" section
//                Section {
//                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken), showLoginPage: .constant(false)) {
//                        Text("Already have an account? Log in here")
//                            .foregroundColor(.blue)
//                    }
//                }
                
            }
            .navigationTitle("Player Details")
        }
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
}


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isLoggedIn: .constant(false), onDetailsSubmitted: {})
    }
}
