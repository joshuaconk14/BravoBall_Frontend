//
//  testNewElement.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/25/25.
//

import SwiftUI
import RiveRuntime

struct testNewElement: View {
    @State private var showFilter: Bool = true
    
    var body: some View {
        if showFilter {
            // Skills for today view
            VStack(alignment: .leading, spacing: 12) {
                // TODO: Replace old skills section with new SkillSelectionView
                Text("Hello")
                    .padding(.vertical, 3)
            }
        } else {
            Button(action: {
                showFilter.toggle()
            }) {
                Text("Show Filters")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
        }
        
    }
}

#Preview {
    testNewElement()
}
