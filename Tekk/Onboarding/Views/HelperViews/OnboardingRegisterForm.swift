//
//  OnboardingRegisterForm.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/8/25.
//

import SwiftUI

struct OnboardingRegisterForm: View {
    @ObservedObject var model: OnboardingModel
    
    let title: String
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var password: String
    
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 18))
                .foregroundColor(model.globalSettings.primaryDarkColor)
            
            
            VStack(spacing: 20) {
                // First Name Field
                TextField("First Name", text: $firstName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(model.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                
                // Last Name Field
                TextField("Last Name", text: $lastName)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(model.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                
                // Username Field
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(model.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                
                // Password Field
                ZStack(alignment: .trailing) {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(model.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                    } else {
                        SecureField("Password", text: $password)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(model.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                    }
                    
                    // Eye icon for password visibility toggle
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(model.globalSettings.primaryYellowColor)
                    }
                    .padding(.trailing, 10)
                }
                
                // Register Button
                Button(action: {
                    // Handle registration logic here
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(model.globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.custom("Poppins-Bold", size: 16))
                }
            }
            .padding(.horizontal)
        }
    }
}

struct OnboardingRegisterForm_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock instance of OnboardingModel for preview
        let mockModel = OnboardingModel()
        let title = "Enter Reg info"
        
        // Create mock bindings for the text inputs
        let firstName = Binding<String>(get: { "John" }, set: { _ in })
        let lastName = Binding<String>(get: { "Doe" }, set: { _ in })
        let email = Binding<String>(get: { "johndoe@gmail.com" }, set: { _ in })
        let password = Binding<String>(get: { "password123" }, set: { _ in })
        
        return OnboardingRegisterForm(model: mockModel, title: title, firstName: firstName, lastName: lastName, email: email, password: password)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
