//
//  CategoryTab.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation
import SwiftUI

struct CategoryTab: View {
    @StateObject private var globalSettings = GlobalSettings()
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(isSelected ? .white : globalSettings.primaryDarkColor)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                        globalSettings.primaryYellowColor :
                        Color.gray.opacity(0.1)
                )
                .cornerRadius(20)
        }
    }
} 
