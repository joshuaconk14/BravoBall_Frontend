//
//  testSesGenView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/22/25.
//

import SwiftUI
import RiveRuntime

struct SessionGeneratorView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @State private var savedFiltersName: String  = ""
    @State private var searchSkillsText: String = ""
    
    
    // MARK: Main view
    var body: some View {
        ZStack(alignment: .bottom) {
            
            // Sky background color
            Color(hex:"bef1fa")
                .ignoresSafeArea()

            homePage

            // Golden button
            if sessionReady()  {
                goldenButton
            }
            
            // Prompt to save filter
            if appModel.viewState.showSaveFiltersPrompt {
                
                saveFiltersPrompt
            }
            
        }

        // Sheet pop-up for each filter
        .sheet(item: $appModel.selectedFilter) { type in
            FilterSheet(
                appModel: appModel,
                sessionModel: sessionModel,
                type: type
            ) {
                appModel.selectedFilter = nil
            }
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(300)])

        }
        // Sheet pop-up for saved filters
        .sheet(isPresented: $appModel.viewState.showSavedFilters) {
            DisplaySavedFilters(
                appModel: appModel,
                sessionModel: sessionModel,
                dismiss: { appModel.viewState.showSavedFilters = false }
            )
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(300)])
        }
        // Sheet pop-up for filter option button
        .sheet(isPresented: $appModel.viewState.showFilterOptions) {
            FilterOptions(
                appModel: appModel,
                sessionModel: sessionModel
            )
            .presentationDragIndicator(.hidden)
            .presentationDetents([.height(200)])
        }
        
    }
    
    
    // MARK: Home page
    private var homePage: some View {
        ZStack(alignment: .top) {

            // Where session begins, behind home page
            AreaBehindHomePage(
                appModel: appModel,
                sessionModel: sessionModel)
            
            
            // Home page
            if appModel.viewState.showHomePage {

                

                // Bravo
                RiveViewModel(fileName: "Bravo_Peaking").view()
                    .frame(width: 90, height: 90)
                    .offset(x: -60)
   
                // Bravo's message bubble
                if appModel.viewState.showPreSessionTextBubble {
                    preSessionMessageBubble
                        .offset(x: 50, y: 20)
                }
  
                // ZStack for rounded corner
                ZStack {
                    
                    // Rounded corner
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    // White part of home page
                    VStack(alignment: .leading, spacing: 5) {
                        
                        HStack {

                            Spacer()
                            
                            SkillSearchBar(appModel: appModel, sessionModel: sessionModel, searchText: $searchSkillsText)
                                .padding(.top, 3)
                            
                            Spacer()
                        }
                        
                        // If skills search bar is selected
                        if appModel.viewState.showSkillSearch {
                            
                            // New view for searching skills
                            SearchSkillsView(
                                appModel: appModel,
                                sessionModel: sessionModel,
                                searchText: $searchSkillsText
                            )
                        // If skills search bar is not selected
                        } else {
                            
                            // Filter options
                            filterScrollView

                            
                            ScrollView {
                                // Generated session portion
                                GeneratedDrillsSection(appModel: appModel, sessionModel: sessionModel)
                            // If user has selected skills
                            if sessionModel.selectedSkills.isEmpty {
                                RecommendedDrillsSection(appModel: appModel, sessionModel: sessionModel)
                            }
                            
                            Spacer()
                            }
                            
                        }
                    }
                }
                .transition(.move(edge: .bottom))
                .padding(.top, 65)
            
            }
        }
        .onAppear {
            BravoTextBubbleDelay()
        }
    }
    
     func BravoTextBubbleDelay() {
        // Initially hide the bubble
        appModel.viewState.showPreSessionTextBubble = false
        
        // Show it after a 1 second delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeIn(duration: 0.3)) {
                appModel.viewState.showPreSessionTextBubble = true
            }
        }
    }

    // MARK: Bravo's message bubble
    private var preSessionMessageBubble: some View {
        ZStack(alignment: .center) {
            HStack(spacing: 0) {
                // Left Pointer
                Path { path in
                    path.move(to: CGPoint(x: 15, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: 10))
                    path.addLine(to: CGPoint(x: 15, y: 20))
                }
                .fill(Color(hex:"E4FBFF"))
                .frame(width: 9, height: 20)
                .offset(y: 1)  // Adjust this to align with text
                
                // Text Bubble
                Text(sessionModel.orderedSessionDrills.isEmpty ? "Choose your skill to improve today" : "Looks like you got \(sessionModel.orderedSessionDrills.count) drills for today!")
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex:"E4FBFF"))
                    )
                    .frame(maxWidth: 150)
 
            }
            .offset(y: -15)
            .transition(.opacity.combined(with: .offset(y: 10)))
        }
    }
     
    // MARK: Filter Scroll View
    private var filterScrollView: some View {
        ZStack(alignment: .leading) {
            
            // Gray line below filters
            Rectangle()
                .stroke(appModel.globalSettings.primaryGrayColor.opacity(0.3), lineWidth: 1)
                .frame(height: 1)
                .offset(y: 30)
            
            // All filter buttons
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
         
                    ForEach(MainAppModel.FilterType.allCases, id: \.self) { type in
                        FilterButton(
                            appModel: appModel,
                            type: type,
                            icon: appModel.icon(for: type),
                            isSelected: appModel.selectedFilter == type,
                            value: sessionModel.filterValue(for: type)
                        ) {
                            if appModel.selectedFilter == type {
                                appModel.selectedFilter = nil
                            } else {
                                appModel.selectedFilter = type
                            }
                        }
                        .padding(.vertical, 3)
                    }
                }
                .frame(height: 50)
            }
            .padding(.leading, 70)
            
            // White filter button on the left
            FilterOptionsButton(appModel: appModel, sessionModel: sessionModel)
             
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 5)
    }
    
    // MARK: Save filters prompt
    private var saveFiltersPrompt: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    appModel.viewState.showSaveFiltersPrompt = false
                }
            
            VStack {
                HStack {
                    // Exit the prompt
                    Button(action: {
                        withAnimation {
                            appModel.viewState.showSaveFiltersPrompt = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                    
                    Spacer()
                    
                    Text("Save filter")
                        .font(.custom("Poppins-Bold", size: 12))
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                TextField("Name", text: $savedFiltersName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Save filters button
                Button(action: {
                    withAnimation {
                        sessionModel.saveFiltersInGroup(name: savedFiltersName)
                        appModel.viewState.showSaveFiltersPrompt = false
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
                .disabled(savedFiltersName.isEmpty)
                .padding(.top, 16)
            }
            .padding()
            .frame(width: 300, height: 170)
            .background(Color.white)
            .cornerRadius(15)
        }
        .onDisappear {
            savedFiltersName = ""
        }
    }
    
    // MARK: Golden Button
    private var goldenButton: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.7)) {
                appModel.viewState.showHomePage = false
                appModel.viewState.showPreSessionTextBubble = false
                
            }
            
            // Delay the appearance of field
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.spring(dampingFraction: 0.7)) {
                    appModel.viewState.showFieldBehindHomePage = true
                }
            }
            
        }) {
            ZStack {
                RiveViewModel(fileName: "Golden_Button").view()
                    .frame(width: 320, height: 80)
                
                Text("Start Session")
                    .font(.custom("Poppins-Bold", size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .padding(.bottom, 10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 46)
        .transition(.move(edge: .bottom))
    }
    
    private func sessionReady() -> Bool {
        !sessionModel.orderedSessionDrills.isEmpty && !appModel.viewState.showSkillSearch && appModel.viewState.showHomePage
    }
    
}

// MARK: Filter Options button
struct FilterOptionsButton: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel

    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    appModel.viewState.showFilterOptions.toggle()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(appModel.globalSettings.primaryLightGrayColor)
                        .frame(width: 40, height: 40)
                        .offset(x: 0, y: 3)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 3)
        }
        .onTapGesture {
            withAnimation {
                if appModel.viewState.showFilterOptions {
                    appModel.viewState.showFilterOptions = false
                }
            }
        }
        .background(Color.white)
    }
    

}


// MARK: Search Skills View
struct SearchSkillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ForEach(filteredSkills, id: \.self) { skill in
                    VStack(alignment: .leading) {
                        SkillRow(
                            appModel: appModel,
                            sessionModel: sessionModel,
                            skill: skill
                        )
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            if sessionModel.selectedSkills.count > 0 {
                Button(action: {
                    searchText = ""
                    appModel.viewState.showSkillSearch = false
                }) {
                    Text("Create Session")
                        .font(.custom("Poppins-Bold", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(12)
                }
                .padding()
            }
            
        }
    }
    
    // Flatten all skills for searching
    private var allSkills: [String] {
        SessionGeneratorView.skillCategories.flatMap { category in
            category.subSkills.map { subSkill in
                (subSkill)
            }
        }
        
    }

    private var filteredSkills: [String] {
        if searchText.isEmpty {
            return []
        } else {
            return allSkills.filter { skill in
                skill.lowercased().contains(searchText.lowercased())
            }
        }
    }
}


// MARK: Skill Row
struct SkillRow: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let skill: String
    
    var body: some View {
        Button( action: {
            if sessionModel.selectedSkills.contains(skill) {
                sessionModel.selectedSkills.remove(skill)
            } else {
                sessionModel.selectedSkills.insert(skill)
            }
        }) {
            HStack {
                Image(systemName: "figure.soccer")
                    .font(.system(size: 24))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(skill)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(.black)
                    Text("Defending")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
    }
    
}


// MARK: Filter button
struct FilterButton: View {
    @ObservedObject var appModel: MainAppModel
    let type: MainAppModel.FilterType
    let icon: MainAppModel.FilterIcon
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

// MARK: Saved Filters

struct DisplaySavedFilters: View {
    @ObservedObject var appModel: MainAppModel
    
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            
            HStack {
                
                Spacer()
                
                Text("Saved Filters")
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                
                Spacer()
                Button(action: {
                    withAnimation(.spring(dampingFraction: 0.7)) {
                        dismiss()
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                }
            }
            
            
            if sessionModel.allSavedFilters.isEmpty {
                Text("No filters saved yet")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(sessionModel.allSavedFilters, id: \.name) { filter in
                            Button(action: {
                                sessionModel.loadFilter(filter)
                            }) {
                                HStack {
                                    Text(filter.name)
                                        .font(.custom("Poppins-Regular", size: 14))
                                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                            }
                            Divider()
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }

}


// MARK: Compact Drill card
// (only displays immutable drill model values)
struct CompactDrillCard: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    
    var body: some View {
        Button(action: {
            appModel.viewState.showingDrillDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 320, height: 170)
                HStack {
                    
                    // Drag handle
                    Image(systemName: "line.3.horizontal")
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        .font(.system(size: 14))
                        .padding(.trailing, 8)
                        
                    Image(systemName: "figure.soccer")
                            .font(.system(size: 24))
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                            Text(drill.title)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            Text("\(drill.sets) sets - \(drill.reps) reps - \(drill.duration)")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                
                Spacer()
                
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $appModel.viewState.showingDrillDetail) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: drill)
        }
    }
}
// MARK: Drill card
struct DrillCard: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var editableDrill: EditableDrillModel
    
    
    var body: some View {
        Button(action: {
            sessionModel.selectedDrillForEditing = editableDrill
            appModel.viewState.showingDrillDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 320, height: 170)
                HStack {
                        // Drag handle
                        Image(systemName: "line.3.horizontal")
                            .padding()
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                            .font(.system(size: 14))
                            .padding(.trailing, 8)
                        
                    Image(systemName: "figure.soccer")
                            .font(.system(size: 24))
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(editableDrill.drill.title)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        Text("\(editableDrill.drill.sets) sets - \(editableDrill.drill.reps) reps - \(editableDrill.drill.duration)")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                
                Spacer()
                
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $appModel.viewState.showingDrillDetail) {
            if let selectedDrill = sessionModel.selectedDrillForEditing,
               let index = sessionModel.orderedSessionDrills.firstIndex(where: {$0.drill.id == selectedDrill.drill.id}) {
                    EditingDrillView(
                        appModel: appModel,
                        sessionModel: sessionModel,
                        editableDrill: $sessionModel.orderedSessionDrills[index])
                }
            
        }
    }
}

// MARK: Recommended Drill card
struct RecommendedDrillCard: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    let drill: DrillModel
    @State private var showingDrillDetail: Bool = false
    
    
    var body: some View {
        Button(action: {
            showingDrillDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 320, height: 170)
                HStack {
                        // Drag handle
                        Image(systemName: "line.3.horizontal")
                            .padding()
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                            .font(.system(size: 14))
                            .padding(.trailing, 8)
                        
                    Image(systemName: "figure.soccer")
                            .font(.system(size: 24))
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading) {
                        Text(drill.title)
                                .font(.custom("Poppins-Bold", size: 16))
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        Text("\(drill.sets) sets - \(drill.reps) reps - \(drill.duration)")
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    }
                
                Spacer()
                
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(appModel.globalSettings.primaryGrayColor)
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDrillDetail) {
                DrillDetailView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    drill: drill
                )
            
            
        }
    }
}

// MARK: Field Drill card
// When session is running
struct FieldDrillCard: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @Binding var editableDrill: EditableDrillModel
    @State private var showingFollowAlong: Bool = false
    
    var body: some View {
        Button(action: {
            showingFollowAlong = true
        }) {
            ZStack {
                // Progress stroke rectangle
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color.gray.opacity(0.3),
                        lineWidth: 7
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .trim(from: 0, to: progress)
                            .stroke(
                                appModel.globalSettings.primaryYellowColor,
                                lineWidth: 7
                            )
                            .animation(.linear, value: progress)
                    )
                    .frame(width: 110, height: 60)
                
                // Drill card
                ZStack {
                    if editableDrill.isCompleted {
                        RiveViewModel(fileName: "Drill_Card_Complete").view()
                        .frame(width: 100, height: 50)
                    } else {
                        RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                        .frame(width: 100, height: 50)
                    }
                    Image(systemName: "figure.soccer")
                        .font(.system(size: 20))
                        .padding()
                        .foregroundColor(editableDrill.isCompleted ? Color.white : appModel.globalSettings.primaryDarkColor)

                }
            }
            
        }
        .buttonStyle(PlainButtonStyle())
        .opacity(editableDrill.isCompleted || isCurrentDrill() ? 1.0 : 0.5)
        .disabled(!editableDrill.isCompleted && !isCurrentDrill())
        .fullScreenCover(isPresented: $showingFollowAlong) {
            DrillFollowAlongView(
                appModel: appModel,
                sessionModel: sessionModel,
                editableDrill: $editableDrill
                )
        }
    }
    
    var progress: Double {
            Double(editableDrill.setsDone) / Double(editableDrill.drill.sets)
        }
    
    private func isCurrentDrill() -> Bool {
        if let firstIncompleteDrill = sessionModel.orderedSessionDrills.first(where: { !$0.isCompleted }) {
            return firstIncompleteDrill.drill.id == editableDrill.drill.id
        }
        return false
    }
}


// MARK: Skill button
struct SkillButton: View {
    @ObservedObject var appModel: MainAppModel
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
            HStack(spacing: 4) {
                Text(title)
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                
                Button(action: action) {
                    Image(systemName: "xmark")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor.opacity(0.5))
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 3)
            .padding(.horizontal, 8)  // Increased horizontal padding for X button
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .stroke(appModel.globalSettings.primaryLightGrayColor, lineWidth: 2)
            )
            .padding(.vertical, 2)
            .padding(.horizontal, 2)
        }
}


// MARK: Skill category button
struct SkillCategoryButton: View {
    let category: SkillCategory
    let isSelected: Bool
    let hasSelectedSubSkills: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected || hasSelectedSubSkills ? .white : .black)
                
                Text(category.name)
                    .font(.custom("Poppins-Bold", size: 16))
                    .foregroundColor(isSelected || hasSelectedSubSkills ? .white : .black)
                
                if hasSelectedSubSkills {
                    Text("Skills selected")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundColor(isSelected || hasSelectedSubSkills ? .white.opacity(0.9) : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected || hasSelectedSubSkills ? Color.yellow : Color.white)
                    .shadow(color: isSelected || hasSelectedSubSkills ?
                           Color.yellow.opacity(0.5) : Color.black.opacity(0.1),
                           radius: 8, x: 0, y: 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected || hasSelectedSubSkills ?
                                   Color.yellow.opacity(0.3) : Color.gray.opacity(0.15),
                                   lineWidth: 2)
                    )
            )
            .scaleEffect(isSelected || hasSelectedSubSkills ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: hasSelectedSubSkills)
        }
    }
}

// MARK: Generated Drills Section

struct GeneratedDrillsSection: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    var body: some View {
            LazyVStack(alignment: .center, spacing: 12) {
                HStack {
                    
                    Button(action: {
                        appModel.viewState.showSearchDrills = true
                    }) {
                        RiveViewModel(fileName: "Plus_Button").view()
                            .frame(width: 30, height: 30)
                    }
                    
                    Button(action: {
                        withAnimation(.spring(dampingFraction: 0.7)) {
                            appModel.viewState.showDeleteButtons.toggle()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .fill(appModel.globalSettings.primaryLightGrayColor)
                                .frame(width: 30, height: 30)
                                .offset(x: 0, y: 3)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "trash")
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                .font(.system(size: 16, weight: .medium))
                        }
                    }

                    Spacer()
                    
                    Text("Session")
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .padding(.trailing, 60)
                    
                    Spacer()

                }
 
                
                if sessionModel.orderedSessionDrills.isEmpty {
                    Spacer()
                    HStack {
                        Image(systemName: "lock.fill")
                            .frame(width: 50, height: 50)
                            .foregroundColor(appModel.globalSettings.primaryLightGrayColor)
                        Text("Choose a skill or drill to create your session")
                            .font(.custom("Poppins-Bold", size: 12))
                            .foregroundColor(appModel.globalSettings.primaryLightGrayColor)
                    }
                    .padding(30)
                    
                } else {
                    ForEach($sessionModel.orderedSessionDrills, id: \.drill.id) { $editableDrill in
                        HStack {
                            if appModel.viewState.showDeleteButtons {
                                Button(action: {
                                    sessionModel.deleteDrillFromSession(drill: editableDrill)
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 20, height: 20)
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: 10, height: 2)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.leading)
                            }
                            
                            DrillCard(
                                appModel: appModel,
                                sessionModel: sessionModel,
                                editableDrill: $editableDrill
                            )
                            .draggable(editableDrill.drill.title) {
                                DrillCard(
                                    appModel: appModel,
                                    sessionModel: sessionModel,
                                    editableDrill: $editableDrill
                                )
                            }
                            .dropDestination(for: String.self) { items, location in
                                guard let sourceTitle = items.first,
                                      let sourceIndex = sessionModel.orderedSessionDrills.firstIndex(where: { $0.drill.title == sourceTitle }),
                                      let destinationIndex = sessionModel.orderedSessionDrills.firstIndex(where: { $0.drill.title == editableDrill.drill.title }) else {
                                    return false
                                }
                                
                                withAnimation(.spring()) {
                                    let movedDrill = sessionModel.orderedSessionDrills.remove(at: sourceIndex)
                                    sessionModel.orderedSessionDrills.insert(movedDrill, at: destinationIndex)
                                }
                                return true
                            }
                        }
                    }
                }

            }
            .padding(.horizontal)
            .padding(.top, 10)
            .cornerRadius(15)
            .sheet(isPresented: $appModel.viewState.showSearchDrills) {
                SearchDrillsSheetView(appModel: appModel, sessionModel: sessionModel, dismiss: { appModel.viewState.showSearchDrills = false })
            }
        
    }
}

// MARK: Recommended Drills Section
struct RecommendedDrillsSection: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    var body: some View {
            VStack {
                HStack {
                    Text("Recommended drills for you:")
                        .font(.custom("Poppins-Bold", size: 17))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .padding(.trailing, 60)
                    Spacer()
                }
                
                LazyVStack {
                    ForEach(sessionModel.recommendedDrills) { testDrill in
                        RecommendedDrillCard(
                            appModel: appModel,
                            sessionModel: sessionModel,
                            drill: testDrill
                        )
                    }
                }
                
            }
            .padding()
            .onAppear {
                loadRandomDrills()
            }
        
    }
    
    // TODO: make it so recommended drills really recommends drills based on users onboarding data
    func loadRandomDrills() {
        guard sessionModel.recommendedDrills.isEmpty else { return }  // Only load if empty
        let randomSet = Array(SessionGeneratorModel.testDrills.shuffled().prefix(3))
        sessionModel.recommendedDrills = randomSet
    }
}

// MARK: Preview
#Preview {
    let mockOnboardingModel = OnboardingModel()
    let mockAppModel = MainAppModel()
    let mockSessionModel = SessionGeneratorModel(onboardingData: OnboardingModel.OnboardingData())
    mockOnboardingModel.onboardingData = OnboardingModel.OnboardingData(
        primaryGoal: "Improve my overall skill level",
        biggestChallenge: "Not knowing what to work on",
        trainingExperience: "Intermediate",
        position: "Striker",
        playstyle: "Alan Virgilus",
        ageRange: "Adult (20-29)",
        strengths: ["Dribbling", "Shooting"],
        areasToImprove: ["Passing", "First touch"],
        trainingLocation: ["field with goals"],
        availableEquipment: ["balls", "cones"],
        dailyTrainingTime: "30-60 minutes",
        weeklyTrainingDays: "4-5 days (moderate schedule)",
        firstName: "John",
        lastName: "Doe",
        email: "john@example.com",
        password: "password123"
    )
    
    
     return SessionGeneratorView(model: mockOnboardingModel, appModel: mockAppModel, sessionModel: mockSessionModel)
}
