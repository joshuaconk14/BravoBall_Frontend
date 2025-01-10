//
//  LoginView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime


// expected response structure from backend after POST request to login endpoint
struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
    let email: String
    let first_name: String
    let last_name: String
}


// Login page
struct LoginView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var userManager: UserManager
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
                Text("Welcome Back!")
                    .font(.custom("PottaOne-Regular", size: 32))
                    .foregroundColor(model.globalSettings.primaryDarkColor)
                
                RiveViewModel(fileName: "Bravo_Panting").view()
                    .frame(width: 200, height: 200)
                    .padding()
                
                VStack(spacing: 15) {
                    // Email field with better constraints
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium))
                        
                        TextField("", text: $email)
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .frame(height: 44)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    
                    // Password field with better constraints
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium))
                        
                        SecureField("", text: $password)
                            .textContentType(.password)
                            .frame(height: 44)
                            .padding(.horizontal)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
            
                
                // Error message
                if !model.errorMessage.isEmpty {
                    Text(model.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .padding(.horizontal)
                }
                
            
                // Login button
                Button(action: {
                    withAnimation(.spring()) {
                        loginUser()
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(model.globalSettings.primaryYellowColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.horizontal)
                .padding(.top)
                
            
                // Cancel button
                Button(action: {
                    withAnimation(.spring()) {
                        resetLoginInfo()
                    }
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(.gray.opacity(0.2))
                        .foregroundColor(model.globalSettings.primaryDarkColor)
                        .cornerRadius(12)
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            // Add this modifier to handle keyboard
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    

    // Resets login info and error message when user cancels login page
    func resetLoginInfo() {
        model.showLoginPage = false
        email = ""
        password = ""
        model.errorMessage = ""
    }

    
    // MARK: - Login user function
    // function for login user
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            self.model.errorMessage = "Please fill in all fields."
            return
        }

        let loginDetails = [
            "email": email,
            "password": password
        ]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/login/")!
        var request = URLRequest(url: url)

        print("current token: \(model.authToken)")
        // HTTP POST request to login user and receive JWT token
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails)

        // Start URL session to interact with backend
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let data = data,
                       let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(self.model.authToken, forKey: "authToken")
                            model.authToken = decodedResponse.access_token
                            model.isLoggedIn = true
                            model.showLoginPage = false
                            
                            userManager.updateUserKeychain(
                                email: decodedResponse.email,
                                firstName: decodedResponse.first_name,
                                lastName: decodedResponse.last_name
                            )
                            
                            print("Login token: \(self.model.authToken)")
                            print("Login success: \(self.model.isLoggedIn)")
                            print("Email: \(decodedResponse.email)")
                            print("First name: \(decodedResponse.first_name)")
                            print("Last name: \(decodedResponse.last_name)")
                        }
                    }
                case 401:
                    DispatchQueue.main.async {
                        self.model.errorMessage = "Invalid credentials, please try again."
                        print("❌ Login failed: Invalid credentials")
                    }
                default:
                    DispatchQueue.main.async {
                        self.model.errorMessage = "Failed to login. Please try again."
                        if let data = data, let responseString = String(data: data, encoding: .utf8) {
                            print("Response data not fully completed: \(responseString)")
                        }
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.model.errorMessage = "Network error. Please try again."
                    print("Login error: \(error.localizedDescription)")
                }
            }
        }.resume()
    }

}
