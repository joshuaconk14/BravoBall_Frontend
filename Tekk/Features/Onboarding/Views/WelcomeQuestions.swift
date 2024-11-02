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
        VStack(spacing: 25) {
            // first name, Zstack so placeholder is on top of input text
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
            
            // last name, Zstack so placeholder is on top of input text
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
            
            // confined version of structure drop down menus
            dropDownMenu(title: $selectedAge, options: ageOptions, placeholder: "Select your Age")
            dropDownMenu(title: $selectedLevel, options: levelOptions, placeholder: "Select your Level")
            dropDownMenu(title: $selectedPosition, options: positionOptions, placeholder: "Select your Position")
                .frame(height: 60)
                .padding(.bottom, 325)
                .transition(.move(edge: .bottom))
        }
        .padding(.horizontal)
        .padding(.top, 500)
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
