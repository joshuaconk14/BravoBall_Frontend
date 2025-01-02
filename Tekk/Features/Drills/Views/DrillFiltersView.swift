//  DrillFilterViews.swift
//  BravoBall
//
//  Created by Jordan on 1/1/25.
//

import Foundation
import SwiftUI

struct DrillFiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var globalSettings = GlobalSettings()
    let difficulties: [String]
    let equipment: [String]
    @Binding var selectedFilters: DrillFilters
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Difficulty Section
                    FilterSection(title: "Difficulty") {
                        ForEach(difficulties, id: \.self) { difficulty in
                            FilterChip(
                                text: difficulty,
                                isSelected: selectedFilters.difficulty == difficulty
                            ) {
                                selectedFilters.difficulty = difficulty
                            }
                        }
                    }
                    
                    // Equipment Section
                    FilterSection(title: "Equipment Available") {
                        ForEach(equipment, id: \.self) { item in
                            FilterChip(
                                text: item,
                                isSelected: selectedFilters.equipment.contains(item)
                            ) {
                                if selectedFilters.equipment.contains(item) {
                                    selectedFilters.equipment.remove(item)
                                } else {
                                    selectedFilters.equipment.insert(item)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedFilters = DrillFilters()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Helper Views
private struct FilterSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("Poppins-Bold", size: 16))
            
            FlowLayout(spacing: 8) {
                content
            }
        }
    }
}

private struct FilterChip: View {
    @StateObject private var globalSettings = GlobalSettings()
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(isSelected ? .white : globalSettings.primaryDarkColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    isSelected ?
                        globalSettings.primaryYellowColor :
                        Color.gray.opacity(0.1)
                )
                .cornerRadius(16)
        }
    }
}

// FlowLayout for wrapping chips
private struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return arrangeSubviews(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let offsets = arrangeSubviews(sizes: sizes, proposal: proposal).offsets
        
        for (offset, subview) in zip(offsets, subviews) {
            subview.place(at: CGPoint(x: bounds.minX + offset.x, y: bounds.minY + offset.y), proposal: .unspecified)
        }
    }
    
    private func arrangeSubviews(sizes: [CGSize], proposal: ProposedViewSize) -> (offsets: [CGPoint], size: CGSize) {
        guard let containerWidth = proposal.width else {
            return ([], .zero)
        }
        
        var offsets: [CGPoint] = []
        var currentPosition = CGPoint.zero
        var maxHeight: CGFloat = 0
        
        for size in sizes {
            if currentPosition.x + size.width > containerWidth {
                currentPosition.x = 0
                currentPosition.y += maxHeight + spacing
                maxHeight = 0
            }
            
            offsets.append(currentPosition)
            currentPosition.x += size.width + spacing
            maxHeight = max(maxHeight, size.height)
        }
        
        let totalHeight = currentPosition.y + maxHeight
        return (offsets, CGSize(width: containerWidth, height: totalHeight))
    }
}
