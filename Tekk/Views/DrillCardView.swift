//
//  DrillCardView.swift
//  BravoBall
//
//  Created by Jordan on 11/12/24.
//

import Foundation
import SwiftUI

struct DrillCardView: View {
    @StateObject private var globalSettings = GlobalSettings()
    let drill: Drill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(drill.title)
                    .font(.custom("Poppins-Bold", size: 18))
                    .foregroundColor(globalSettings.primaryDarkColor)
                
                Spacer()
                
                Text("\(drill.duration) mins")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.gray)
            }
            
            Text(drill.description)
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundColor(.gray)
            
            // Equipment section
            if !drill.equipment.isEmpty {
                Text("Equipment needed:")
                    .font(.custom("Poppins-Bold", size: 14))
                ForEach(drill.equipment, id: \.self) { item in
                    Text("• \(item)")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(.gray)
                }
            }
            
            Button(action: {}) {
                Text("Start Drill")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(globalSettings.primaryYellowColor)
                    .cornerRadius(20)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}
