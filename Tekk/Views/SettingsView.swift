//
//  SettingsView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the SettingsView, which is used to display the settings for the user.

import SwiftUI

struct SettingsView: View {
    @StateObject private var globalSettings = GlobalSettings()

    @State private var name = "Jordan Conklin"
    @State private var email = "jordinhoconk@gmail.com"
    @State private var showDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode ////////

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
                    
                    deleteAccountButton
                        .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color.white)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                },
                secondaryButton: .cancel()
            )
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
                Text(name)
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
    
    private var deleteAccountButton: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            Text("Delete Account")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(globalSettings.primaryYellowColor)
                .cornerRadius(10)
        }
        .padding(.top, 20)
    }
}

// Preview code
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            SettingsView()
                .previewDisplayName("Light Mode")
            
            // Dark mode preview
            SettingsView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            // Different device sizes
            SettingsView()
                .previewDevice("iPhone SE (3rd generation)")
                .previewDisplayName("iPhone SE")
            
            SettingsView()
                .previewDevice("iPhone 15 Pro Max")
                .previewDisplayName("iPhone 15 Pro Max")
        }
    }
}
