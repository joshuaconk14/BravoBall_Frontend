//
//  WelcomeView.swift
//  BravoBall
//
//  Created by Josh on 9/28/24.
//  This file contains the LoginView, which is used to welcome the user.

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var stateManager: OnboardingStateManager
    @EnvironmentObject var coordinator: OnboardingCoordinator
    @StateObject private var globalSettings = GlobalSettings()
    @Binding var isLoggedIn: Bool
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var selectedAgeRange = ""
    @State private var selectedLevel = ""
    @State private var selectedPosition = ""
    
    let ageRanges = ["Youth (8-12)", "Teen (13-16)", "High School (14-18)", "College (18-22)", "Adult (23+)"]
    let levels = ["Beginner", "Intermediate", "Advanced", "Elite"]
    let positions = ["Guard", "Forward", "Center", "Not Sure"]
    
    var isFormValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty &&
        !selectedAgeRange.isEmpty && !selectedLevel.isEmpty &&
        !selectedPosition.isEmpty
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Welcome to BravoBall")
                    .font(.custom("PottaOne-Regular", size: 32))
                    .foregroundColor(globalSettings.primaryYellowColor)
                    .padding(.top, 20)
                
                Text("Let's get to know you better")
                    .font(.custom("Poppins-Regular", size: 16))
                    .foregroundColor(globalSettings.primaryDarkColor)
                
                VStack(alignment: .leading, spacing: 15) {
                    CustomTextField(text: $firstName, placeholder: "First Name", title: "First Name")
                    CustomTextField(text: $lastName, placeholder: "Last Name", title: "Last Name")
                    
                    CustomPicker(selection: $selectedAgeRange,
                               options: ageRanges,
                               title: "Age Range")
                    
                    CustomPicker(selection: $selectedLevel,
                               options: levels,
                               title: "Level")
                    
                    CustomPicker(selection: $selectedPosition,
                               options: positions,
                               title: "Position")
                }
                .padding(.horizontal)
                
                Button(action: {
                    stateManager.updateWelcomeData(
                        firstName: firstName,
                        lastName: lastName,
                        ageRange: selectedAgeRange,
                        level: selectedLevel,
                        position: selectedPosition
                    )
                    coordinator.navigateToStep(.firstQuestionnaire)
                }) {
                    Text("Continue")
                        .frame(width: 325, height: 15)
                        .padding()
                        .background(isFormValid ? globalSettings.primaryYellowColor : .gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                .disabled(!isFormValid)
                .padding(.top, 30)
                
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Poppins-Regular", size: 16))
        }
    }
}

struct CustomPicker: View {
    @Binding var selection: String
    let options: [String]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
            
            Picker(title, selection: $selection) {
                Text("Select \(title)").tag("")
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}


//// MARK: - Preview
//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        let stateManager = OnboardingStateManager()
//        WelcomeView(
//            isLoggedIn: .constant(false),
//            showWelcome: .constant(false)
//        )
//        .environmentObject(stateManager)
//    }
//}
