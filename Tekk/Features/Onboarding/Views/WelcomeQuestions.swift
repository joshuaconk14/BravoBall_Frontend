//
//  WelcomeQuestions.swift
//  BravoBall
//
//  Created by Joshua Conklin on 10/7/24.
//
// This file displays the views for the questions that get the player's basic information like name, position, and palying level

import SwiftUI
import RiveRuntime

// MARK: - WelcomeQuestions
struct WelcomeQuestions: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var welcomeInput: Int
    @Binding var firstName: String
    @Binding var lastName: String
    
    //  options for lists
    let ageOptions = Array (5...100).map { String($0) }
    let levelOptions = ["Beginner", "Intermediate", "Competitive", "Professional"]
    let positionOptions = ["Goalkeeper", "Fullback", "Centerback", "Defensive Mid", "Central Mid", "Attacking Mid", "Winger", "Forward"]
    
    @Binding var selectedAge: String
    @Binding var selectedLevel: String
    @Binding var selectedPosition: String
    
    @State private var isEditingFirstName = false
    @State private var isEditingLastName = false
    
    var body: some View {
        VStack(spacing: 15) {
            // first name
            ZStack(alignment: .leading) {
                if firstName.isEmpty {
                    Text("First Name")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                TextField("", text: $firstName)
                    .padding()
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            
            // last name (same modifications as first name)
            ZStack(alignment: .leading) {
                if lastName.isEmpty {
                    Text("Last Name")
                        .foregroundColor(.gray)
                        .padding(.leading, 16)
                        .font(.custom("Poppins-Bold", size: 16))
                }
                TextField("", text: $lastName)
                    .padding()
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .frame(height: 60)
            .padding(.horizontal, 20)
            
            // dropdown menus
            DropdownMenu(title: $selectedAge, options: ageOptions, placeholder: "Select your Age")
            DropdownMenu(title: $selectedLevel, options: levelOptions, placeholder: "Select your Level")
            DropdownMenu(title: $selectedPosition, options: positionOptions, placeholder: "Select your Position")
        }
        .padding(.top, 20)
    }
}

// MARK: - Preview for WelcomeQuestions
struct WelcomeQuestions_Previews: PreviewProvider {
    @State static var welcomeInput = 0
    @State static var firstName = ""
    @State static var lastName = ""
    @State static var selectedAge = "Select your Age"
    @State static var selectedLevel = "Select your Level"
    @State static var selectedPosition = "Select your Position"
    
    static var previews: some View {
        WelcomeQuestions(
            welcomeInput: $welcomeInput,
            firstName: $firstName,
            lastName: $lastName,
            selectedAge: $selectedAge,
            selectedLevel: $selectedLevel,
            selectedPosition: $selectedPosition
        )
        .background(Color.white)
    }
}
