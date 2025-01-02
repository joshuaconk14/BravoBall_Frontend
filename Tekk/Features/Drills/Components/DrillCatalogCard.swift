//
//  DrillCatalogCard.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation
import SwiftUI

// View for the drill catalog card that displays the drill title, category, duration, and difficulty
struct DrillCatalogCard: View {
    @StateObject private var globalSettings = GlobalSettings()
    let drill: DrillRecommendation
    
    var body: some View {
        // Navigation link to the drill detail view with the drill as the destination
        NavigationLink(destination: DrillDetailView(drill: drill)) {
            VStack(alignment: .leading, spacing: 8) {
                // Title and Duration
                HStack {
                    Text(drill.title)
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text("\(drill.duration) mins")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(.gray)
                }
                
                // Description
                Text(drill.description)
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                // Category and Difficulty Pills
                HStack(spacing: 8) {
                    // Category
                    Text(drill.category)
                        .font(.custom("Poppins-Bold", size: 12))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(globalSettings.primaryYellowColor.opacity(0.2))
                        .cornerRadius(12)
                    
                    // Equipment (first item only)
                    if let firstEquipment = drill.recommended_equipment.first {
                        Text(firstEquipment)
                            .font(.custom("Poppins-Regular", size: 12))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(globalSettings.primaryYellowColor.opacity(0.2), lineWidth: 1)
            )
        }
    }
}
