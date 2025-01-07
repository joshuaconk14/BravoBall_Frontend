//
//  SettingsView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the SettingsView, which is used to display the settings for the user.

import SwiftUI

struct SettingsView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @EnvironmentObject var stateManager: OnboardingStateManager
    @Binding var isLoggedIn: Bool

    @State private var showAlert = false
    @State private var alertType: AlertType = .none
    @Environment(\.presentationMode) var presentationMode // ?
    
    enum AlertType {
        case logout
        case delete
        case none
    }

    
    private var firstName: String {
        stateManager.onboardingData.firstName
    }
    private var lastName: String {
        stateManager.onboardingData.lastName
    }
    private var email: String {
        stateManager.onboardingData.email
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    profileHeader
                    
                    actionSection(title: "Account", buttons: [
                        customActionButton(title: "Favorite Conversations", icon: "heart.fill"),
                        customActionButton(title: "Share With a Friend", icon: "square.and.arrow.up.fill"),
                        customActionButton(title: "Edit your details", icon: "pencil")
                    ])
                    
                    actionSection(title: "Support", buttons: [
                        customActionButton(title: "Report an Error", icon: "exclamationmark.bubble.fill"),
                        customActionButton(title: "Talk to a Founder", icon: "phone.fill"),
                        customActionButton(title: "Drop a Rating", icon: "star.fill"),
                        customActionButton(title: "Follow our Socials", icon: "link")
                    ])
                    
                    logoutButton
                        .padding(.top, 50)
                        .padding(.horizontal)
                    deleteAccountButton
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
            }
        }
        // the different alerts for logout or delete
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $showAlert) {
            switch alertType {
            case .logout:
                return Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to Logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        UserDefaults.standard.removeObject(forKey: "accessToken")
                        isLoggedIn = false
                    },
                    secondaryButton: .cancel()
                )
            case .delete:
                return Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        // Handle delete account
                        deleteAccount()
                        UserDefaults.standard.removeObject(forKey: "accessToken")
                        isLoggedIn = false
                    },
                    secondaryButton: .cancel()
                )
            case .none:
                return Alert(title: Text(""))
            }
        }
    }
    
     
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
            }
            .foregroundColor(globalSettings.primaryYellowColor)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 5) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(globalSettings.primaryYellowColor)
            
            VStack(spacing: 0) {
                Text("\(firstName) \(lastName)")
                    .font(.custom("Poppins-Bold", size: 18))
                
                Text(email)
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
    }
    
    private func actionSection(title: String, buttons: [AnyView]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
           Text(title)
               .font(.custom("Poppins-Bold", size: 20))
               .foregroundColor(globalSettings.primaryDarkColor)
               .padding(.leading)
               .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                ForEach(buttons.indices, id: \.self) { index in
                    buttons[index]
                    
                    if index < buttons.count - 1 {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
    
    private func customActionButton(title: String, icon: String) -> AnyView {
        AnyView(
            Button(action: {
                // Action here
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(globalSettings.primaryYellowColor)
                    Text(title)
                        .font(.custom("Poppins-Regular", size: 16))
                        .foregroundColor(globalSettings.primaryDarkColor)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(globalSettings.primaryDarkColor.opacity(0.7))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .buttonStyle(PlainButtonStyle())
        )
    }
    
    private var logoutButton: some View {
        Button(action: {
            alertType = .logout
            showAlert = true
            
        }) {
            Text("Logout")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(globalSettings.primaryYellowColor)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            alertType = .delete
            showAlert = true
        }) {
            Text("Delete Account")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }
    
    
    
    
    
    private func deleteAccount() {
        // Create URL for the delete endpoint
        guard let url = URL(string: "http://127.0.0.1:8000/delete-account/") else {
            print("❌ Invalid URL")
            return
        }
        
        // Get the access token from UserDefaults storage
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else {
            print("❌ No access token found")
            return
        }
        
        // set DELETE method w/ access token stored in the request's value
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        // debug to make sure token is created
        print("\n🔍 Request Details:")
        print("URL: \(url)")
        print("Method: \(request.httpMethod ?? "")")
        
        print("headers:")
        // ?
        request.allHTTPHeaderFields?.forEach { key, value in
                print("\(key): \(value)")
            }
        
        
        // Make the network request to the backend with the created "request"
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error deleting account: \(error)")
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Invalid response")
                    return
                }
                
                // Debug print the response
                print("📥 Backend response status: \(httpResponse.statusCode)")
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
                
                if httpResponse.statusCode == 200 {
                    print("✅ Account deleted successfully")
                    // Account deletion successful - handled in the alert action
                    // The alert action already handles logging out and removing the token
                } else {
                    print("❌ Failed to delete account: \(httpResponse.statusCode)")
                    // You might want to show an error message to the user here
                }
            }
        }.resume()
    }
    
    
    
    
}

// Preview code
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let mockStateManager = OnboardingStateManager()
        
        // Set up mock data for preview
        mockStateManager.updateRegister(
            firstName: "Jordan",
            lastName: "Conklin",
            email: "jordinhoconk@gmail.com",
            password: "password123"
        )
        
        return Group {
            SettingsView(isLoggedIn: .constant(true))
                .environmentObject(mockStateManager)
                .previewDisplayName("Light Mode")
            
            SettingsView(isLoggedIn: .constant(true))
                .environmentObject(mockStateManager)
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            SettingsView(isLoggedIn: .constant(true))
                .environmentObject(mockStateManager)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE")
            
            SettingsView(isLoggedIn: .constant(true))
                .environmentObject(mockStateManager)
                .previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro Max"))
                .previewDisplayName("iPhone 15 Pro Max")
        }
    }
}
