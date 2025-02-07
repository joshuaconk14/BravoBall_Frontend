////
////  testNewElement.swift
////  BravoBall
////
////  Created by Joshua Conklin on 1/25/25.
////
//
//import SwiftUI
//import RiveRuntime
//
//struct testNewElement: View {
//    @ObservedObject var appModel: MainAppModel
//    @State private var showSavedPrereqsPrompt = false
//    @Binding var savedFiltersName: String
//    
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    showSavedPrereqsPrompt = false
//                }) {
//                    Image(systemName: "xmark")
//                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
//                        .font(.system(size: 16, weight: .medium))
//
//                }
//
//                Spacer()
//
//                Text("Save filter")
//                    .font(.custom("Poppins-Bold", size: 12))
//                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
//                Spacer()
//            }
//            .padding(.horizontal, 16)
//            .padding(.top, 8)
//
//            TextField("Name", text: $savedFiltersName)
//                .padding(12)
//                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
//                .overlay(RoundedRectangle(cornerRadius: 10).stroke(appModel.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
//                .disableAutocorrection(true)
//                .keyboardType(.default)
//                .padding(.horizontal, 16)
//                .padding(.top, 8)
//
//            Button(action: {
//                showSavedPrereqsPrompt = false
//            }) {
//                Text("Save")
//                    .padding(.horizontal)
//                    .padding(.vertical, 3)
//                    .font(.custom("Poppins-Bold", size: 12))
//                    .foregroundColor(savedFiltersName.isEmpty ? appModel.globalSettings.primaryGrayColor : .white)
//                    .background(
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(savedFiltersName.isEmpty ? appModel.globalSettings.primaryLightestGrayColor : appModel.globalSettings.primaryYellowColor)
//                    )
//
//            }
//            .padding(.top, 16)
//            .disabled(savedFiltersName.isEmpty)
//        }
//        .padding()
//        .frame(maxWidth: 300, maxHeight: 170)
//        .background(Color.white)
//        .cornerRadius(15)
//        .background(
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.white)
//                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
//        )
//        .padding(.bottom, 400)
//    }
//}
//
//#Preview {
//    let mockAppModel = MainAppModel()
//    let name = Binding<String>(get: { "Virginius esque" }, set: { _ in })
//    
//    testNewElement(appModel: mockAppModel, savedFiltersName: name)
//}
