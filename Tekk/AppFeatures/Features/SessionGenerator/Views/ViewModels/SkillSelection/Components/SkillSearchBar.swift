//
//  SkillSearchBar.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/24/25.
//

import SwiftUI
import RiveRuntime

struct SkillSearchBar: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @State private var showingSkillSelector = false
    @FocusState private var isFocused: Bool
    @Binding var searchText: String
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            
            HStack {
                if appModel.viewState.showSkillSearch {
                    Button( action: {
                        searchText = ""
                        appModel.viewState.showSkillSearch = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                            .padding(.vertical, 3)
                    }
                }
                
                // Full Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    // Horizontal scrolling selected skills
                        VStack {
                            if !sessionModel.selectedSkills.isEmpty {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 4) {
                                        ForEach(Array(sessionModel.selectedSkills).sorted(), id: \.self) { skill in
                                            SkillButton(
                                                appModel: appModel,
                                                title: skill,
                                                isSelected: true
                                            ) {
                                                sessionModel.selectedSkills.remove(skill)
                                            }
                                        }
                                    }
                                }
                            }
                            TextField(sessionModel.selectedSkills.isEmpty ? "Search skills..." : "Select more...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .tint(appModel.globalSettings.primaryYellowColor)
                                .focused($isFocused)
                                .onChange(of: isFocused) { _, newValue in
                                    updateSearchState(isFocused: newValue)
                                }
                                .onChange(of: appModel.viewState.showSkillSearch) { _, newValue in
                                    updateSearchState(isShowing: newValue)
                                }
                            
                            }
                    
                    Spacer()
                    

                    if !appModel.viewState.showSkillSearch {
                        Button(action: { showingSkillSelector = true }) {
                            RiveViewModel(fileName: "Plus_Button").view()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(8)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isFocused ? appModel.globalSettings.primaryYellowColor : appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
                )
                .cornerRadius(20)
                .padding(.top, 13)

            }
            
        }
        .padding(.horizontal, 8)
        .sheet(isPresented: $showingSkillSelector) {
            SkillSelectorSheet(appModel: appModel, sessionModel: sessionModel)
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
    }
    private func updateSearchState(isFocused: Bool? = nil, isShowing: Bool? = nil) {
           if let isFocused = isFocused {
               if isFocused {
                   appModel.viewState.showSkillSearch = true
               }
           }
           
           if let isShowing = isShowing {
               if !isShowing {
                   self.isFocused = false
               }
           }
       }
}
