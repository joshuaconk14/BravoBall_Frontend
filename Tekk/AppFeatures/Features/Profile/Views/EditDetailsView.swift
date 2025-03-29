//
//  EditDetailsView.swift
//  BravoBall
//
//  Created by Jordan on 3/28/25.
//

import SwiftUI

struct EditDetailsView: View {
    @ObservedObject var settingsModel: SettingsModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }
            }
            .navigationTitle("Edit Details")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { saveChanges() }
            )
        }
        .onAppear {
            firstName = settingsModel.firstName
            lastName = settingsModel.lastName
            email = settingsModel.email
        }
        .alert("Update Status", isPresented: $showAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func saveChanges() {
        Task {
            do {
                try await settingsModel.updateUserDetails(
                    firstName: firstName,
                    lastName: lastName,
                    email: email
                )
                alertMessage = "Details updated successfully"
                showAlert = true
                dismiss()
            } catch {
                alertMessage = "Failed to update details: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
