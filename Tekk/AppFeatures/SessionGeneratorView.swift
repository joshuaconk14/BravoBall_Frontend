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

//    init(model: OnboardingModel, appModel: MainAppModel) {
//        self.model = model
//        self.appModel = appModel
//
//    }
    
    
    // MARK: Main view
    var body: some View {
            ZStack(alignment: .bottom) {
                
                // Sky background color
                Color(hex:"bef1fa")
                    .ignoresSafeArea()
                

                homePage


                // Golden button
                    
                if !sessionModel.orderedDrills.isEmpty && !appModel.viewState.showSkillSearch && appModel.viewState.showHomePage  {
                        
                        goldenButton
                }
                
                // Prompt to save filter
                if appModel.viewState.showSavedPrereqsPrompt {
                    
                    prereqPrompt
                }
                
            }
            .background(Color(hex:"bef1fa"))

            .sheet(item: $appModel.selectedPrerequisite) { type in
                    PrerequisiteDropdown(
                        appModel: appModel,
                        sessionModel: sessionModel,
                        type: type
                    ) {
                        appModel.selectedPrerequisite = nil
                    }
                    .presentationDragIndicator(.hidden)
//                    .interactiveDismissDisabled()
                    .presentationDetents([.height(300)])

                }
            .sheet(isPresented: $appModel.viewState.showSavedPrereqs) {
                DisplaySavedFilters(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    dismiss: { appModel.viewState.showSavedPrereqs = false }
                )
                .presentationDragIndicator(.hidden)
//                .interactiveDismissDisabled()
                .presentationDetents([.height(300)])
            }
            .sheet(isPresented: $appModel.viewState.showFilterOptions) {
                FilterOptions(
                    appModel: appModel,
                    sessionModel: sessionModel
                )
                .presentationDragIndicator(.hidden)
//                .interactiveDismissDisabled()
                .presentationDetents([.height(200)])
            }
    }
    
    
    // MARK: Home page
    private var homePage: some View {
        ZStack(alignment: .top) {

            // Where session begins, behind home page
            areaBehindHomePage
                
                
                
            // Home page
            if appModel.viewState.showHomePage {
                VStack {
                    HStack {
                        // Bravo
                        RiveViewModel(fileName: "Bravo_Panting").view()
                            .frame(width: 60, height: 60)
                        
                        // Bravo's message bubble
                        ZStack(alignment: .center) {
                            RiveViewModel(fileName: "Message_Bubble").view()
                                .frame(width: 170, height: 50)

                            if appModel.viewState.showTextBubble {
                                if sessionModel.orderedDrills.isEmpty {
                                    Text("Choose your skill to improve today")
                                        .font(.custom("Poppins-Bold", size: 12))
                                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                        .padding(10)
                                        .frame(maxWidth: 150)
                                } else {
                                    
                                    Text("Looks like you got \(sessionModel.orderedDrills.count) drills for today!")
                                        .font(.custom("Poppins-Bold", size: 12))
                                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                        .padding(10)
                                        .frame(maxWidth: 150)
                                }
                            }
                        }
                    }
                    
                // ZStack for rounded corner
                ZStack {
                    
                    // Rounded corner
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .fill(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    // Home page
                    VStack(alignment: .leading, spacing: 5) {
                        
                        HStack {

                            Spacer()
                            
                            // Skills for today view
                            SkillSelectionView(appModel: appModel, sessionModel: sessionModel, searchText: $searchSkillsText)
                                .padding(.top, 3)
                            
                            Spacer()
                        }
                        
                        if appModel.viewState.showSkillSearch {
                            SearchSkillsView(
                                appModel: appModel,
                                sessionModel: sessionModel,
                                searchText: $searchSkillsText
                            )
                        } else {
                            
                            prerequisiteScrollView

                            // Generated Drills Section
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
    
    // MARK: Area behind home page
    private var areaBehindHomePage: some View {
        // Whole area behind the home page
        VStack {
            
            
            Spacer()

                // When the session is activated
            if appModel.viewState.showSmallDrillCards {
                ZStack {
                    RiveViewModel(fileName: "Grass_Field").view()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    HStack {
                        RiveViewModel(fileName: "Bravo_Panting").view()
                            .frame(width: 90, height: 90)
                        VStack {
                            ForEach(sessionModel.orderedDrills, id: \.drill.id) { editableDrill in
                                if let index = sessionModel.orderedDrills.firstIndex(where: {$0.drill.id == editableDrill.drill.id}) {
                                    SmallDrillCard(
                                        appModel: appModel,
                                        sessionModel: sessionModel,
                                        editableDrill: $sessionModel.orderedDrills[index]
                                    )
                                }
                                
                            }
                        }
                        .padding()
                    }
                        // back button to go back to home page
                        HStack {
                            Spacer()
                            
                            Button(action:  {
                                withAnimation(.spring(dampingFraction: 0.7)) {
                                    appModel.viewState.showSmallDrillCards = false
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    withAnimation(.spring(dampingFraction: 0.7)) {
                                        appModel.viewState.showHomePage = true
                                        appModel.viewState.showTextBubble = true
                                    }
                                }
                            }) {
                                Text("End Session")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .frame(width: 150, height: 44)
                                    .background(
                                        RoundedRectangle(cornerRadius: 22)
                                            .fill(Color.red)
                                    )
                            }
                            
                            
                        }
                        .padding()
                        .padding(.top, 500) // TODO: find better way to style this
                    
                }
                .transition(.move(edge: .bottom))
            }
        }
        
    }
    
    
    // MARK: Prerequisite Scroll View
    private var prerequisiteScrollView: some View {
        ZStack(alignment: .leading) {
            
            Rectangle()
                .stroke(appModel.globalSettings.primaryGrayColor.opacity(0.3), lineWidth: 1)
                .frame(height: 1)
                .offset(y: 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
         
                    // All prereqs
                    ForEach(MainAppModel.PrerequisiteType.allCases, id: \.self) { type in
                        PrerequisiteButton(
                            appModel: appModel,
                            type: type,
                            icon: appModel.icon(for: type),
                            isSelected: appModel.selectedPrerequisite == type,
                            value: prerequisiteValue(for: type)
                        ) {
                            if appModel.selectedPrerequisite == type {
                                appModel.selectedPrerequisite = nil
                            } else {
                                appModel.selectedPrerequisite = type
                            }
                        }
                        .padding(.vertical, 3)
                    }
                    
                }
                
            }
            .padding(.leading, 70)
            
            FilterButton(appModel: appModel, sessionModel: sessionModel)
             
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 5)
    }
    
    // MARK: prereq prompt
    private var prereqPrompt: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    appModel.viewState.showSavedPrereqsPrompt = false
                }
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            appModel.viewState.showSavedPrereqsPrompt = false
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
                
                Button(action: {
                    withAnimation {
                        saveFiltersInGroup(name: savedFiltersName)
                        appModel.viewState.showSavedPrereqsPrompt = false
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
            
            // Delay the appearance of drill cards to match the menu's exit animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation(.spring(dampingFraction: 0.7)) {
                    appModel.viewState.showSmallDrillCards = true
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
            
    // Prereq value that is selected, or if its empty
    private func prerequisiteValue(for type: MainAppModel.PrerequisiteType) -> String {
        switch type {
        case .time:
            return sessionModel.selectedTime ?? ""
        case .equipment:
            return sessionModel.selectedEquipment.isEmpty ? "" : "\(sessionModel.selectedEquipment.count) selected"
        case .trainingStyle:
            return sessionModel.selectedTrainingStyle ?? ""
        case .location:
            return sessionModel.selectedLocation ?? ""
        case .difficulty:
            return sessionModel.selectedDifficulty ?? ""
        }
    }
    
    
    // Save prerequisites
    
    private func saveFiltersInGroup(name: String) {
        
        guard !name.isEmpty else { return }
        
        let savedFilters = SavedFiltersModel(
            name: name,
            savedTime: sessionModel.selectedTime,
            savedEquipment: sessionModel.selectedEquipment,
            savedTrainingStyle: sessionModel.selectedTrainingStyle,
            savedLocation: sessionModel.selectedLocation,
            savedDifficulty: sessionModel.selectedDifficulty
        )
        
        sessionModel.allSavedFilters.append(savedFilters)
    }
    
}


// TODO: make this neater

// MARK: Filter button
struct FilterButton: View {
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

// MARK: Filter Options
struct FilterOptions: View {
    
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                
                clearPrereqSelection()
                
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
                
                showPrereqPrompt()
                
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
                    appModel.viewState.showSavedPrereqs.toggle()
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
    private func showPrereqPrompt() {
        if appModel.viewState.showSavedPrereqsPrompt == true {
            appModel.viewState.showSavedPrereqsPrompt = false
        } else {
            appModel.viewState.showSavedPrereqsPrompt = true
        }
    }
    
    // Clears prereq selected options
    private func clearPrereqSelection() {
        sessionModel.selectedTime = nil
        sessionModel.selectedEquipment.removeAll()
        sessionModel.selectedTrainingStyle = nil
        sessionModel.selectedLocation = nil
        sessionModel.selectedDifficulty = nil
    }


    
    private func showSavedPrerequisites() {
        if appModel.viewState.showSavedPrereqs == true {
            appModel.viewState.showSavedPrereqs = false
        } else {
            appModel.viewState.showSavedPrereqs = true
        }
    }
}

// MARK: Search Skills View
struct SearchSkillsView: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    @Binding var searchText: String
    
    // Flatten all skills for searching
        var allSkills: [String] {
            SessionGeneratorView.skillCategories.flatMap { category in
                category.subSkills.map { subSkill in
                    (subSkill)
                }
            }
            
        }
        
        var filteredSkills: [String] {
            if searchText.isEmpty {
                return []
            } else {
                return allSkills.filter { skill in
                    skill.lowercased().contains(searchText.lowercased())
                }
            }
        }
    
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


// MARK: Prereq button
struct PrerequisiteButton: View {
    @ObservedObject var appModel: MainAppModel
    let type: MainAppModel.PrerequisiteType
    let icon: MainAppModel.PrerequisiteIcon
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
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(value.isEmpty ? Color(hex:"#f5cc9f") : Color(hex:"eb9c49"))
                    .stroke(value.isEmpty ? Color(hex:"f5cc9f") : Color(hex:"b37636"), lineWidth: 3)
            )
            .scaleEffect(isSelected ? 0.85 : 0.8)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        }
    }
}

// MARK: Prereq dropdown
struct PrerequisiteDropdown: View {
    @ObservedObject var appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    
    let type: MainAppModel.PrerequisiteType
    let dismiss: () -> Void
    
    var body: some View {
        // Prereq dropdown
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
                                loadFilter(filter)
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
    // Load filter after clicking the name of saved filter
    private func loadFilter(_ filter: SavedFiltersModel) {
            sessionModel.selectedTime = filter.savedTime
            sessionModel.selectedEquipment = filter.savedEquipment
            sessionModel.selectedTrainingStyle = filter.savedTrainingStyle
            sessionModel.selectedLocation = filter.savedLocation
            sessionModel.selectedDifficulty = filter.savedDifficulty
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
    let editableDrill: EditableDrillModel
    @State private var showingDrillDetail = false
    
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
        .sheet(isPresented: $showingDrillDetail) {
            if let index = sessionModel.orderedDrills.firstIndex(where: {$0.drill.id == editableDrill.drill.id}) {
                EditingDrillView(
                    appModel: appModel,
                    sessionModel: sessionModel,
                    editableDrill: $sessionModel.orderedDrills[index])
            }
            
        }
    }
}

// MARK: Small Drill card
// When session is running
struct SmallDrillCard: View {
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
                .padding()
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
        if let firstIncompleteDrill = sessionModel.orderedDrills.first(where: { !$0.isCompleted }) {
            return firstIncompleteDrill.drill.id == editableDrill.drill.id
        }
        return false
    }
}




// MARK: Skill selection view
struct SkillSelectionView: View {
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
                                .focused($isFocused)
                                .onChange(of: isFocused) {
                                    if isFocused {
                                        appModel.viewState.showSkillSearch = true
                                    }
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
                        .stroke(appModel.globalSettings.primaryLightGrayColor, lineWidth: 3)
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
                    .disabled(sessionModel.orderedDrills.isEmpty)
                    .opacity(sessionModel.orderedDrills.isEmpty ? 0.4 : 1.0)
                    
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
                    .disabled(sessionModel.orderedDrills.isEmpty)
                    .opacity(sessionModel.orderedDrills.isEmpty ? 0.4 : 1.0)

                    Spacer()
                    
                    Text("Session")
                        .font(.custom("Poppins-Bold", size: 20))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .padding(.trailing, 60)
                    
                    Spacer()

                }
                
                
                if sessionModel.orderedDrills.isEmpty {
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
                    ForEach(sessionModel.orderedDrills, id: \.drill.id) { editableDrill in
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
                                editableDrill: editableDrill
                            )
                            .draggable(editableDrill.drill.title) {
                                DrillCard(
                                    appModel: appModel,
                                    sessionModel: sessionModel,
                                    editableDrill: editableDrill
                                )
                            }
                            .dropDestination(for: String.self) { items, location in
                                guard let sourceTitle = items.first,
                                      let sourceIndex = sessionModel.orderedDrills.firstIndex(where: { $0.drill.title == sourceTitle }),
                                      let destinationIndex = sessionModel.orderedDrills.firstIndex(where: { $0.drill.title == editableDrill.drill.title }) else {
                                    return false
                                }
                                
                                withAnimation(.spring()) {
                                    let movedDrill = sessionModel.orderedDrills.remove(at: sourceIndex)
                                    sessionModel.orderedDrills.insert(movedDrill, at: destinationIndex)
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
