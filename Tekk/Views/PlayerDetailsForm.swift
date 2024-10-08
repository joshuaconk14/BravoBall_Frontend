//
//  PlayerDetailsFormView.swift
//  Tekk
//
//  Created by Jordan on 8/26/24.
//  This file contains the PlayerDetailsFormView, which is used to collect player details for the user.

import Foundation
import SwiftUI

struct PlayerDetailsFormView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var age = ""
    @State private var position = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSubmitted = false
    @Binding var isLoggedIn: Bool
    @State private var errorMessage = ""
    @State private var authToken = ""
    
    var onDetailsSubmitted: () -> Void // Closure to notify when details are submitted

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Information")) {
                    TextField("First Name", text: $firstName)
                        .disableAutocorrection(true)
                    TextField("Last Name", text: $lastName)
                        .disableAutocorrection(true)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                    TextField("Position", text: $position)
                        .disableAutocorrection(true)
                }

                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextField("Password", text: $password)
                        .disableAutocorrection(true)
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: submitDetails) {
                    Text("Submit")
                }
                .disabled(isSubmitted)

//                // "Already have an account?" section
//                Section {
//                    NavigationLink(destination: LoginView(isLoggedIn: $isLoggedIn, authToken: $authToken), showLoginPage: .constant(false)) {
//                        Text("Already have an account? Log in here")
//                            .foregroundColor(.blue)
//                    }
//                }
            }
            .navigationTitle("Player Details")
        }
    }

    func submitDetails() {
        guard let ageInt = Int(age), !firstName.isEmpty, !lastName.isEmpty, !position.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields correctly."
            return
        }

        let playerInfo = [
            "first_name": firstName,
            "last_name": lastName,
            "age": ageInt,
            "position": position,
            "email": email,
            "password": password
        ] as [String : Any]

        // sending HTTP POST request to FastAPI app running locally
        let url = URL(string: "http://127.0.0.1:8000/register/")!
        var request = URLRequest(url: url)

        // HTTP POST request to store player details
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // attempt to serialize the response
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: playerInfo)
        } catch {
            print("Error serializing player details: \(error)")
            errorMessage = "Failed to prepare registration data."
            return
        }

        // Send JSON payload to backend through URL session
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Network error. Please try again."
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid server response."
                }
                return
            }

            // If valid URL response, return status code 200 and proceed
            print("Status code: \(httpResponse.statusCode)")

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }

            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.isSubmitted = true
                    self.errorMessage = ""
                    self.onDetailsSubmitted()
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to submit details. Please try again. (Status: \(httpResponse.statusCode))"
                }
            }
        }.resume()
    }
}

//
//struct PlayerDetailsFormView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayerDetailsFormView(isLoggedIn: .constant(false), onDetailsSubmitted: {})
//    }
//}
