//
//  DropdownMenu.swift
//  BravoBall
//
//  Created by Josh on 10/31/24.
//
// This file is to display the dropdown menu when the user clicks on the dropdown button

import SwiftUI
import Foundation

// MARK: - Drop Down Menu (for Q1)
struct dropDownMenu: View {
    @StateObject private var globalSettings = GlobalSettings()

    @Binding var title: String
    var options: [String]
    var placeholder: String
    @State private var showList: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    showList.toggle()
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
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            
            if showList {
                VStack {
                    ScrollView {
                        // lazy for better performance
                        LazyVStack {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    title = option
                                    showList = false
                                }) {
                                    //edit inside drop down element
                                    Text(option)
                                        .padding()
                                        .foregroundColor(globalSettings.primaryDarkColor)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.custom("Poppins-Bold", size: 16))
                                }
                                // edit full drop down menu appearance
                                .background(.white)
                            }
                        }
                    }
                    .frame(maxHeight: 200) // Limit dropdown height
                }
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .zIndex(1)
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Preview for DropDownMenu
struct DropDownMenu_Previews: PreviewProvider {
    @State static var selectedOption = "Select Option"
    static let options = ["Option 1", "Option 2", "Option 3"]
    
    static var previews: some View {
        dropDownMenu(
            title: $selectedOption,
            options: options,
            placeholder: "Select an Option"
        )
        .frame(height: 60)
        .padding(.horizontal)
        .background(Color.white)
    }
}
