//
//  FilterButton.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/25/25.
//
import SwiftUI

struct FilterButton: View {
    @ObservedObject var appModel: MainAppModel
    let type: FilterType
    let icon: FilterIcon
    let isSelected: Bool
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.7)) {
                action()
            }
        }) {
            HStack {
                icon.view
                    .scaleEffect(0.7)
                    
                
                Text(value.isEmpty ? type.rawValue : value)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(value.isEmpty ? Color(hex:"#f5cc9f") : Color(hex:"eb9c49"))
                    .stroke(isSelected ? appModel.globalSettings.primaryYellowColor : Color.clear, lineWidth: 5)
            )
            .scaleEffect(isSelected ? 0.85 : 0.8)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        }
    }
}
