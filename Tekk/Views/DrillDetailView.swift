//
//  DrillDetailView.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation
import SwiftUI

struct DrillDetailView: View {
    @StateObject private var globalSettings = GlobalSettings()
    @Environment(\.dismiss) private var dismiss
    let drill: DrillRecommendation
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(drill.title)
                        .font(.custom("Poppins-Bold", size: 24))
                        .foregroundColor(globalSettings.primaryDarkColor)
                    
                    HStack(spacing: 12) {
                        CategoryPill(text: drill.category)
                        DifficultyPill(text: drill.difficulty)
                        DurationPill(duration: drill.duration)
                    }
                }
                .padding(.horizontal)
                
                // Equipment Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "Equipment Needed")
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(drill.recommended_equipment, id: \.self) { item in
                                EquipmentTag(text: item)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Instructions Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "Instructions")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(drill.instructions.enumerated()), id: \.offset) { index, instruction in
                            HStack(alignment: .top, spacing: 12) {
                                Text("\(index + 1)")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(globalSettings.primaryYellowColor)
                                    .frame(width: 24, height: 24)
                                    .background(Circle().fill(globalSettings.primaryYellowColor.opacity(0.2)))
                                
                                Text(instruction)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Tips Section
                VStack(alignment: .leading, spacing: 12) {
                    SectionTitle(text: "Pro Tips")
                    
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(drill.tips, id: \.self) { tip in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(globalSettings.primaryYellowColor)
                                
                                Text(tip)
                                    .font(.custom("Poppins-Regular", size: 16))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {}) {
                    Text("Start Drill")
                        .font(.custom("Poppins-Bold", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(globalSettings.primaryYellowColor)
                        .cornerRadius(20)
                }
                .padding(.horizontal)
            }
        }
    }
}

// Helper Views
private struct SectionTitle: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Bold", size: 18))
            .foregroundColor(.black)
    }
}

private struct CategoryPill: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Regular", size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

private struct DifficultyPill: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Regular", size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

private struct DurationPill: View {
    let duration: Int
    
    var body: some View {
        Text("\(duration) mins")
            .font(.custom("Poppins-Regular", size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

private struct EquipmentTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom("Poppins-Regular", size: 14))
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}
