//
//  SavedDrillsView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI

struct SavedDrillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @State private var showCreateGroup: Bool = false
    @State private var savedGroupName: String = ""
    
    // MARK: Main view
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        
                        // Progress header
                        Text("Saved Drills")
                            .font(.custom("Poppins-Bold", size: 18))
                            .foregroundColor(.black)
                            .padding()
                        Spacer()
                        
                        Button(action: {
                            showCreateGroup = true
                        }) {
                            Text("Create")
                                .font(.custom("Poppins-Bold", size: 12))
                                .foregroundColor(.black)
                        }
                        .padding()
                    }
                    
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 5) {
                        }
                    }
                }
                
                if showCreateGroup {
                    createGroup
                }
            }
        }
    }
    
    // MARK: Create group
    private var createGroup: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    showCreateGroup = false
                }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            showCreateGroup = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Save group")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                TextField("Name", text: $savedGroupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                Button(action: {
                    withAnimation {
                        showCreateGroup = false
                    }
                }) {
                    Text("Save")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(appModel.globalSettings.primaryYellowColor)
                        .cornerRadius(8)
                }
                .disabled(savedGroupName.isEmpty)
                .padding(.top, 16)
            }
            .padding()
            .frame(width: 300, height: 170)
            .background(Color.white)
            .cornerRadius(15)
        }
    }
}

struct allGroups {
    let name: String
    let description: String
    let drills: [DrillModel]
}

// MARK: Group Display
struct groupDisplay: View {
    let appModel: MainAppModel
    
    var body: some View {
        VStack {
            Image(systemName: "figure.soccer")
                .font(.system(size: 24))
                .padding()
                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

#Preview {
    let mockAppModel = MainAppModel()
    let mockSesGenModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    
    
    SavedDrillsView(appModel: mockAppModel, sessionModel: mockSesGenModel)
}
