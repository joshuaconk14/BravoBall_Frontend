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
                VStack {
                    HStack {
                        // Bravo
                        RiveViewModel(fileName: "Bravo_Panting").view()
                            .frame(width: 60, height: 60)
                        
                        // Bravo's message bubble
                        if appModel.viewState.showTextBubble {
                            
                            preSessionMessageBubble
                        }
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

                            // Generated session portion
                            GeneratedDrillsSection(appModel: appModel, sessionModel: sessionModel)
                        }
                    }
                }
            }
            .transition(.move(edge: .bottom))
            .padding(.top, 3)
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
                appModel.viewState.showTextBubble = false
                
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

// MARK: Filter button
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

// MARK: Area behind home page
struct AreaBehindHomePage: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
        
    var body: some View {
        // Whole area behind the home page
        VStack {
            
            Spacer()

            // When the session begins, the field pops up
            if appModel.viewState.showFieldBehindHomePage {
                ZStack {
                    RiveViewModel(fileName: "Grass_Field").view()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    
                    HStack {
                        
                        VStack {
                            
                            sessionMessageBubble
 
                            RiveViewModel(fileName: "Bravo_Panting").view()
                                .frame(width: 90, height: 90)
                        }
     
                        
                        VStack(spacing: 15) {
                            
                            // Ordered drill cards on the field
                            ForEach(sessionModel.orderedSessionDrills, id: \.drill.id) { editableDrill in
                                if let index = sessionModel.orderedSessionDrills.firstIndex(where: {$0.drill.id == editableDrill.drill.id}) {
                                    FieldDrillCard(
                                        appModel: appModel,
                                        sessionModel: sessionModel,
                                        editableDrill: $sessionModel.orderedSessionDrills[index]
                                    )
                                }
                            }
                            
                            // Trophy button for completionview
                            trophyButton
                        }
                        .padding()
                    }
                    
                    // TODO: add button that will end session early and save users progress into calendar
                    
                    // back button only shows if session not completed
                    if sessionModel.sessionNotComplete() {
                        HStack {
                            VStack(alignment: .leading) {
                                
                                Button(action:  {
                                    withAnimation(.spring(dampingFraction: 0.7)) {
                                        appModel.viewState.showFieldBehindHomePage = false
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation(.spring(dampingFraction: 0.7)) {
                                            appModel.viewState.showHomePage = true
                                            appModel.viewState.showTextBubble = true
                                        }
                                    }
                                }) {
                                    Image(systemName: "door.left.hand.open")
                                        .foregroundColor(.black.opacity(0.5))
                                        .font(.system(size: 35, weight: .semibold))
                                    
                                }
                                RiveViewModel(fileName: "Break_Area").view()
                                    .frame(width: 120, height: 120)
                                
                            }

                            
                            Spacer()

                        }
                        .padding()
                        .padding(.top, 500) // TODO: find better way to style this
                    }
                    
                    
                }
                .transition(.move(edge: .bottom))
            }
        }
        .fullScreenCover(isPresented: $appModel.viewState.showSessionComplete) {
            SessionCompleteView(
                appModel: appModel, sessionModel: sessionModel
            )
        }
    }
    
    private var trophyButton: some View {
        Button(action: {
            appModel.viewState.showSessionComplete = true
        }) {
            Image("BravoBall_Trophy")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 90)
        }
        .padding(.top, 20)
        .disabled(sessionModel.sessionNotComplete())
        .opacity(sessionModel.sessionNotComplete() ? 0.5 : 1.0)
    }
    
    private var sessionMessageBubble: some View {
        VStack(spacing: 0) {
            
            Text(sessionModel.sessionNotComplete() ? "You have \(sessionModel.sessionsLeftToComplete()) drills left" : "Well done! Click on the trophy to claim your prize")
                .font(.custom("Poppins-Bold", size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex:"60AE17"))
                )
                .frame(maxWidth: 150)
                .transition(.opacity.combined(with: .offset(y: 10)))
            
            // Pointer
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 10, y: 10))
                path.addLine(to: CGPoint(x: 20, y: 0))
            }
            .fill(Color(hex:"60AE17"))
            .frame(width: 20, height: 10)
        }
    }
}




// MARK: Filter Options
struct FilterOptions: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    // TODO: case enums for neatness
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                
                clearFilterSelection()
                
                withAnimation {
                    appModel.viewState.showFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Clear Filters")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Button(action: {
                
                showFilterPrompt()
                
                withAnimation {
                    appModel.viewState.showFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Save Filters")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            
            Divider()
            
            Button(action: {
                withAnimation(.spring(dampingFraction: 0.7)) {
                    appModel.viewState.showSavedFilters.toggle()
                    appModel.viewState.showFilterOptions = false
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "list.bullet")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Text("Show Saved Filters")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
        }
        .padding(8)
        .background(Color.white)
        .frame(maxWidth: .infinity)

    }
    
    // Show Save Filter prompt
    private func showFilterPrompt() {
        if appModel.viewState.showSaveFiltersPrompt == true {
            appModel.viewState.showSaveFiltersPrompt = false
        } else {
            appModel.viewState.showSaveFiltersPrompt = true
        }
    }
    
    // Clears filter selected options
    private func clearFilterSelection() {
        sessionModel.selectedTime = nil
        sessionModel.selectedEquipment.removeAll()
        sessionModel.selectedTrainingStyle = nil
        sessionModel.selectedLocation = nil
        sessionModel.selectedDifficulty = nil
    }


    
    private func showSavedFilters() {
        if appModel.viewState.showSavedFilters == true {
            appModel.viewState.showSavedFilters = false
        } else {
            appModel.viewState.showSavedFilters = true
        }
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

// MARK: Filter dropdown
struct FilterSheet: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    let type: MainAppModel.FilterType
    let dismiss: () -> Void
    
    var body: some View {
        // Filter dropdown
        VStack(alignment: .center, spacing: 12) {
            
            // Header
            HStack {
                Spacer()
                Text(type.rawValue)
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
            
            // Options list
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(optionsForType, id: \.self) { option in
                        Button(action: {
                            selectOption(option)
                        }) {
                            HStack {
                                Text(option)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                                Spacer()
                                if isSelected(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(appModel.globalSettings.primaryYellowColor)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
            }
        }
        .padding()
    }
    
    
    private var optionsForType: [String] {
        switch type {
        case .time: return sessionModel.timeOptions
        case .equipment: return sessionModel.equipmentOptions
        case .trainingStyle: return sessionModel.trainingStyleOptions
        case .location: return sessionModel.locationOptions
        case .difficulty: return sessionModel.difficultyOptions
        }
    }
    
    private func isSelected(_ option: String) -> Bool {
        switch type {
        case .time: return sessionModel.selectedTime == option
        case .equipment: return sessionModel.selectedEquipment.contains(option)
        case .trainingStyle: return sessionModel.selectedTrainingStyle == option
        case .location: return sessionModel.selectedLocation == option
        case .difficulty: return sessionModel.selectedDifficulty == option
        }
    }

    private func selectOption(_ option: String) {
        switch type {
        case .time:
            if sessionModel.selectedTime == option {
                sessionModel.selectedTime = nil
            } else {
                sessionModel.selectedTime = option
            }
        case .equipment:
            if sessionModel.selectedEquipment.contains(option) {
                sessionModel.selectedEquipment.remove(option)
            } else {
                sessionModel.selectedEquipment.insert(option)
            }
        case .trainingStyle:
            if sessionModel.selectedTrainingStyle == option {
                sessionModel.selectedTrainingStyle = nil
            } else {
                sessionModel.selectedTrainingStyle = option
            }
        case .location:
            if sessionModel.selectedLocation == option {
                sessionModel.selectedLocation = nil
            } else {
                sessionModel.selectedLocation = option
            }
        case .difficulty:
            if sessionModel.selectedDifficulty == option {
                sessionModel.selectedDifficulty = nil
            } else {
                sessionModel.selectedDifficulty = option
            }
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
            .padding()
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




// MARK: Skill selection view
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


// MARK: Skill selector sheet
struct SkillSelectorSheet: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @Environment(\.dismiss) private var dismiss
    @State private var expandedCategory: String?
    

    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text("Select Skills")
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding(.leading, 70)
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                    
                    .padding()
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .font(.custom("Poppins-Bold", size: 16))
                }
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 40) {
                        ForEach(SessionGeneratorView.skillCategories, id: \.name) { category in
                            VStack(alignment: .leading, spacing: 0) {
                                Button(action: {
                                    withAnimation {
                                        if expandedCategory == category.name {
                                            expandedCategory = nil
                                        } else {
                                            expandedCategory = category.name
                                        }
                                    }
                                }) {
                                    VStack {
                                        Text(category.name)
                                            .font(.custom("Poppins-Bold", size: 18))
                                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                        HStack {
                                            Spacer()
                                            
                                            Image(systemName: category.icon)
                                                .font(.system(size: 20))
                                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                            
                                            Spacer()

                                        }
                                        .padding()
                                        
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .stroke(isCategorySelected(category) ? appModel.globalSettings.primaryYellowColor : Color.gray.opacity(0.3), lineWidth: 4)
                                    )
                                }
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                
                                if expandedCategory == category.name {
                                    VStack(spacing: 12) {
                                        ForEach(category.subSkills, id: \.self) { subSkill in
                                            Button(action: {
                                                if sessionModel.selectedSkills.contains(subSkill) {
                                                    sessionModel.selectedSkills.remove(subSkill)
                                                } else {
                                                    sessionModel.selectedSkills.insert(subSkill)
                                                }
                                            }) {
                                                HStack {
                                                    Text(subSkill)
                                                        .font(.custom("Poppins-Medium", size: 16))
                                                    
                                                    Spacer()
                                                    
                                                    if sessionModel.selectedSkills.contains(subSkill) {
                                                        Image(systemName: "checkmark.circle.fill")
                                                            .foregroundColor(appModel.globalSettings.primaryYellowColor)
                                                    }
                                                }
                                                .padding(.horizontal)
                                                .padding(.vertical, 8)
                                            }
                                            .foregroundColor(appModel.globalSettings.primaryDarkColor)                                    }
                                    }
                                    .padding(.vertical)
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(12)
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .safeAreaInset(edge: .bottom) {
                if sessionModel.selectedSkills.count > 0 {
                    Button(action: {
                        dismiss()
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
    // TODO: move this somewhere else?
    // Highlight category if sub skill selected
    func isCategorySelected(_ category: SkillCategory) -> Bool {
        for skill in category.subSkills {
            if sessionModel.selectedSkills.contains(skill) {
                return true
            }
        }
        return false
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
        ScrollView {
            LazyVStack(alignment: .center, spacing: 12) {
                HStack {
                    
                    Button(action: {
                        appModel.viewState.showSearchDrills = true
                    }) {
                        RiveViewModel(fileName: "Plus_Button").view()
                            .frame(width: 30, height: 30)
                    }
                    .disabled(sessionModel.orderedSessionDrills.isEmpty)
                    .opacity(sessionModel.orderedSessionDrills.isEmpty ? 0.4 : 1.0)
                    
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
                    .disabled(sessionModel.orderedSessionDrills.isEmpty)
                    .opacity(sessionModel.orderedSessionDrills.isEmpty ? 0.4 : 1.0)

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
                        Text("Choose a skill to create your session")
                            .font(.custom("Poppins-Bold", size: 12))
                            .foregroundColor(appModel.globalSettings.primaryLightGrayColor)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 150)
                    
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
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .cornerRadius(15)
        .sheet(isPresented: $appModel.viewState.showSearchDrills) {
            SearchDrillsSheetView(appModel: appModel, sessionModel: sessionModel, dismiss: { appModel.viewState.showSearchDrills = false })
        }
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
