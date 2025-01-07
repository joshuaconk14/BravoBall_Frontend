//
//  CustomTextField.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/6/25.
//

import SwiftUI
import Foundation

struct CustomTextField: View {
    @StateObject private var globalSettings = GlobalSettings()
    
    let placeholder: String
    let icon: String
    @Binding var text: String
    
    // not private so can place it in preview struct
    var isSecure: Bool = false // makes it so only the password has the visibility toggle
    @State private var isTextVisible: Bool = false // this allows users to switch between states, isSecure will handle if this is applied or not
    var keyboardType: UIKeyboardType = .default
    
    
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(globalSettings.primaryYellowColor)
                .frame(width: 20)
            
            if isSecure { // traits for password input
                ZStack(alignment: .trailing) {
                    if isTextVisible {
                        TextField(placeholder, text: $text) // regular text
                            .font(.custom("Poppins-Bold", size: 16))
                            .autocapitalization(.none)
                            .keyboardType(keyboardType)
                    } else {
                        SecureField(placeholder, text: $text) // hidden text
                            .font(.custom("Poppins-Bold", size: 16))
                            .autocapitalization(.none)
                            .keyboardType(keyboardType)
                    }
                    
                    // Add eye icon for password visibility toggle
                    Button(action: {
                        isTextVisible.toggle() // allows users to switch between states
                    }) {
                        Image(systemName: isTextVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(globalSettings.primaryYellowColor)
                    }
                }
            } else { // all other inputs
                TextField(placeholder, text: $text)
                    .font(.custom("Poppins-Bold", size: 16))
                    .autocapitalization(.none)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1)
        )
    }
}

// Preview
struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            CustomTextField(
                placeholder: "First Name",
                icon: "person",
                text: .constant("")
            )
            CustomTextField(
                placeholder: "Last Name",
                icon: "person",
                text: .constant("")
            )
            CustomTextField(
                placeholder: "Email",
                icon: "envelope",
                text: .constant(""),
                keyboardType: .emailAddress
            )
            
            CustomTextField(
                placeholder: "Password",
                icon: "key",
                text: .constant(""),
                isSecure: true
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
