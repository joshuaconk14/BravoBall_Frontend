//
//  QuestionsView.swift
//  Tekk
//
//  Created by Joshua Conklin on 10/7/24.
//
import SwiftUI
import RiveRuntime


// MARK: - welcomeQs
struct welcomeQs: View {
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



