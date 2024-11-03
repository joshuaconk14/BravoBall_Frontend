//
//  SelectionListView.swift
//  BravoBall
//
//  Created by Jordan on 11/1/24.
//  This is a component for displaying the view of questionnaire items

import Foundation
import SwiftUI

struct SelectionListView<T: Hashable>: View {
    let items: [T]
    let maxSelections: Int
    @Binding var selectedItems: [T]
    let itemTitle: (T) -> String
    
    var body: some View {
        VStack(spacing: 25) {
            LazyVStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    SelectionListItem(
                        text: itemTitle(item),
                        isSelected: selectedItems.contains(item)
                    ) {
                        toggleSelection(item)
                    }
                }
            }
        }
    }
    
    private func toggleSelection(_ item: T) {
        if selectedItems.contains(item) {
            selectedItems.removeAll { $0 == item }
        } else if selectedItems.count < maxSelections {
            selectedItems.append(item)
        }
    }
}

// MARK: - Preview
struct SelectionListView_Previews: PreviewProvider {
    // Sample data for preview
    static let sampleItems = [
        "Option 1",
        "Option 2",
        "Option 3",
        "Option 4"
    ]
    
    @State static var selectedItems: [String] = ["Option 2"]
    
    static var previews: some View {
        SelectionListView(
            items: sampleItems,
            maxSelections: 2,
            selectedItems: $selectedItems
        ) { item in
            item // Simple string conversion for preview
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
