//
//  LoginView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime

// Login page
struct LoginView: View {
    @ObservedObject var model: OnboardingModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back!")
                .font(.custom("PottaOne-Regular", size: 32))
                .foregroundColor(model.globalSettings.primaryDarkColor)
            
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 200, height: 200)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            Button(action: {
                // Handle login
            }) {
                Text("Login")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(model.globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            
            Button("Cancel") {
                withAnimation(.spring()) {
                    model.showLoginPage = false
                }
            }
            .foregroundColor(model.globalSettings.primaryDarkColor)
        }
        .padding()
        .background(Color.white)
    }
}
