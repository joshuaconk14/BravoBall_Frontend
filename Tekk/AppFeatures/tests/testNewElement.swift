//
//  testNewElement.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/25/25.
//

import SwiftUI
import RiveRuntime

struct testNewElement: View {
    @ObservedObject var appModel: MainAppModel
    @State private var showSavedPrereqsPrompt = false
    @Binding var savedFiltersName: String
    
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(Color.white)
            
                .frame(width: 300, height: 100)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(appModel.globalSettings.primaryLightGrayColor,
                                lineWidth: 2)
                )
            VStack {
                HStack {
                    Button(action: {
                        showSavedPrereqsPrompt = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.leading, 7)
                        
                    }
                    
                    Spacer()
                    
                    Text("Save filter")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    Spacer()
                }
                .padding()
                
                TextField("Name", text: $savedFiltersName)
                    .padding()
                    .disableAutocorrection(true)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(appModel.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
                    .keyboardType(.default)
                Button(action: {
                    showSavedPrereqsPrompt = false
                }) {
                    Text("Save")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    
                }
            }
            
        }
        .padding()
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    let name = Binding<String>(get: { "Virginius esque" }, set: { _ in })
    
    testNewElement(appModel: mockAppModel, savedFiltersName: name)
}
