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
    let ageOptions = [
            "Youth (Under 12)",
            "Teen (13-16)",
            "Junior (17-19)",
            "Adult (20-29)",
            "Senior (30+)"
        ]
    let levelOptions = ["Beginner", "Intermediate", "Competitive", "Professional"]
    let positionOptions = ["Goalkeeper", "Fullback", "Centerback", "Defensive Mid", "Central Mid", "Attacking Mid", "Winger", "Forward"]
    
    @Binding var selectedAge: String
    @Binding var selectedLevel: String
    @Binding var selectedPosition: String
    
    @State private var isEditingFirstName = false
    @State private var isEditingLastName = false
    
    @State private var openMenu: String? = nil // Add this to track which menu is open
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                // Add some top padding to account for Bravo and the question
                Spacer()
                    .frame(height: 275) // Adjust this value based on your needs
                
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
                
                // last name
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

                // dropdown menus
                VStack(spacing: 15) {
                    DropdownMenu(
                        title: $selectedAge,
                        options: ageOptions,
                        placeholder: "Select your Age Range",
                        isOpen: Binding(
                            get: { openMenu == "age" },
                            set: { if $0 { openMenu = "age" } else { openMenu = nil } }
                        )
                    )
                    .zIndex(3)
                    
                    DropdownMenu(
                        title: $selectedLevel,
                        options: levelOptions,
                        placeholder: "Select your Level",
                        isOpen: Binding(
                            get: { openMenu == "level" },
                            set: { if $0 { openMenu = "level" } else { openMenu = nil } }
                        )
                    )
                    .zIndex(2)
                    
                    DropdownMenu(
                        title: $selectedPosition,
                        options: positionOptions,
                        placeholder: "Select your Position",
                        isOpen: Binding(
                            get: { openMenu == "position" },
                            set: { if $0 { openMenu = "position" } else { openMenu = nil } }
                        )
                    )
                    .zIndex(1)
                }
                
                // Add bottom spacing to ensure content doesn't get hidden behind the Next button
                Spacer()
                    .frame(height: 100)
            }
            .padding(.horizontal)
        }
        .scrollDisabled(false) // Enable scrolling
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
