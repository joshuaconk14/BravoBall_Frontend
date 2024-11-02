//
//  SelectionListItem.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//
//  This is a component for showing each questionnaire item

import Foundation
import SwiftUI

struct SelectionListItem: View {
    @StateObject private var globalSettings = GlobalSettings()
    
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .foregroundColor(globalSettings.primaryDarkColor)
                    .padding()
                    .font(.custom("Poppins-Bold", size: 16))
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(globalSettings.primaryDarkColor)
                }
            }
            .background(isSelected ? globalSettings.primaryYellowColor : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
