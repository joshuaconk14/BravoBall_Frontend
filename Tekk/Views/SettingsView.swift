//
//  SettingsView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the SettingsView, which is used to display the settings for the user.

import SwiftUI

struct SettingsView: View {
    @State private var name = "Jordan Conklin"
    @State private var email = "jordinhoconk@gmail.com"
    @State private var showDeleteConfirmation = false
    @Environment(\.presentationMode) var presentationMode ////////

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    profileHeader
                    
                    // Text("Account")
                    //     .font(.headline)
                    //     .frame(maxWidth: .infinity, alignment: .leading)
                    //     .padding(.leading)
                        
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
                }
                .padding()
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
            .foregroundColor(.green)
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 5) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.green)
            
            VStack(spacing: 0) {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
        .shadow(radius: 2)
    }
    
    private func actionSection(title: String, buttons: [AnyView]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
           Text(title)
               .font(.headline)
               .foregroundColor(.black)
               .padding(.leading)
            ForEach(buttons.indices, id: \.self) { index in
                buttons[index]
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.90)))
        .shadow(radius: 1)
    }
    
    private func customActionButton(title: String, icon: String) -> AnyView {
        AnyView(
            Button(action: {
                // Action here
            }) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.green)
                    Text(title)
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.black.opacity(0.7))
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.90)))
            }
            .buttonStyle(PlainButtonStyle())
        )
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            showDeleteConfirmation = true
        }) {
            Text("Delete Account")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
        }
        .padding(.top, 20)
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
//
