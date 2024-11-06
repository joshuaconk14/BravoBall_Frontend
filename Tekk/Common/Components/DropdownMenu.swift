//
//  DropDownMenu.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is to display the dropdown menu when the user clicks on the dropdown button

import SwiftUI
import Foundation

// MARK: - Drop Down Menu (for Q1)
struct DropdownMenu: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var title: String
    var options: [String]
    var placeholder: String
    @Binding var isOpen: Bool
    
    var body: some View {
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation(.linear(duration: 0.2)) {
                        isOpen.toggle()
                    }
                }) {
                    HStack {
                        Text(title.isEmpty ? placeholder : title)
                            .foregroundColor(title.isEmpty ? .gray : globalSettings.primaryDarkColor)
                            .padding(.leading, 16)
                            .font(.custom("Poppins-Bold", size: 16))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .padding(.trailing, 16)
                            .foregroundColor(globalSettings.primaryDarkColor)
                    }
                    .frame(height: 60)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1))
                }
                
                if isOpen {
                    VStack {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(options, id: \.self) { option in
                                    Button(action: {
                                        title = option
                                        isOpen = false
                                    }) {
                                        Text(option)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 16)
                                            .foregroundColor(globalSettings.primaryDarkColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.custom("Poppins-Bold", size: 16))
                                    }
                                    .background(.white)
                                }

                            }

                        }
                        .frame(maxHeight: 200)
                    }
                    .background(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                }
            }
        }
}

// MARK: - Preview for DropDownMenu
struct DropdownMenu_Previews: PreviewProvider {
    @State static var selectedOption = "Select Option"
    static let options = ["Option 1", "Option 2", "Option 3"]
    
    static var previews: some View {
        DropdownMenu(
            title: $selectedOption,
            options: options,
            placeholder: "Select an Option",
            isOpen: .constant(false)
        )
        .padding()
        .background(Color.white)
    }
}
