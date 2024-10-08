//
//  LoginView.swift
//  Tekk
//
//  Created by Jordan on 8/26/24.
//  This file contains the LoginView, which is used to login the user.

import SwiftUI
import RiveRuntime


// expected response structure from backend after POST request to login endpoint
struct LoginResponse: Codable {
    let access_token: String
    let token_type: String
}

struct ConversationsResponse: Codable {
    let conversations: [Conversation]
}

// MARK: - Main body
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var conversations: [Conversation] = []
    @Binding var isLoggedIn: Bool
    @Binding var authToken: String
    @Binding var showLoginPage: Bool // Binding to control visibility of the login page
    
    
    var body: some View {
        VStack {
            HStack {
                //back button
                Button(action: {
                    withAnimation(.spring()) {
                        showLoginPage = false
                        
                    }
                }){
                    Image(systemName:"arrow.left")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }
                .padding()
                
                Spacer() // moving back button to left
            }


            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Poppins-Bold", size: 16))
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Poppins-Bold", size: 16))
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Button(action: loginUser) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "947F63"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            
            // Action for creating an account
            Button(action: {
            }) {
                Text("Forgot my Password")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            
            
            Spacer()
        }
        .padding()
        .background(Color(hex:"1E272E"))
    }

    
    // MARK: - User function
    // function for login user
    func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            return
        }

        let loginDetails = [
            "email": email,
            "password": password
        ]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/login/")!
        var request = URLRequest(url: url)

        print("current token: \(authToken)")
        // HTTP POST request to login user and receive JWT token
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginDetails)

        // start URL session to interact with backend
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let decodedResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                DispatchQueue.main.async {
                    self.authToken = decodedResponse.access_token
                    self.isLoggedIn = true
                    print("Login token: \(self.authToken)")
                    print("Login success: \(self.isLoggedIn)")
                    // TODO make this a secure key
                    UserDefaults.standard.set(self.authToken, forKey: "authToken")

                    // // Fetch conversations after successful login
                    // self.fetchConversations()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to login. Please try again."
                    if let error = error {
                        print("Login error: \(error.localizedDescription)")
                    }
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                }
            }
        }.resume()
    }

}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(isLoggedIn: .constant(false), authToken: .constant(""), showLoginPage: .constant(true))
//    }
//}
