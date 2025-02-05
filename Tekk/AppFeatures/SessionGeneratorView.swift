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
    @State private var selectedPrerequisite: PrerequisiteType?
    
    @State private var savedFiltersName: String  = ""
    
//    init(model: OnboardingModel, appModel: MainAppModel) {
//        self.model = model
//        self.appModel = appModel
//
//    }

    
    enum PrerequisiteType: String, CaseIterable {
        case time = "Time"
        case equipment = "Equipment"
        case trainingStyle = "Training Style"
        case location = "Location"
        case difficulty = "Difficulty"
    }
    
    
    enum PrerequisiteIcon {
        case time
        case equipment
        case trainingStyle
        case location
        case difficulty
        
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .time:
                RiveViewModel(fileName: "Prereq_Time").view()
                    .frame(width: 30, height: 30)
            case .equipment:
                RiveViewModel(fileName: "Prereq_Equipment").view()
                    .frame(width: 30, height: 30)
            case .trainingStyle:
                RiveViewModel(fileName: "Prereq_Training_Style").view()
                    .frame(width: 30, height: 30)
            case .location:
                RiveViewModel(fileName: "Prereq_Location").view()
                    .frame(width: 30, height: 30)
            case .difficulty:
                RiveViewModel(fileName: "Prereq_Difficulty").view()
                    .frame(width: 30, height: 30)
            }
        }
    }
    
    // Function to map PrerequisiteType to PrerequisiteIcon
    func icon(for type: PrerequisiteType) -> PrerequisiteIcon {
        switch type {
        case .time:
            return .time
        case .equipment:
            return .equipment
        case .trainingStyle:
            return .trainingStyle
        case .location:
            return .location
        case .difficulty:
            return .difficulty
        }
    }
    
    
    // MARK: Main view
    var body: some View {
            ZStack(alignment: .bottom) {
                
                homePage

                // Golden button
                    
                if !sessionModel.orderedDrills.isEmpty {
                    if appModel.viewState.showHomePage {
                        
                        goldenButton
                    }
                }
                
                // Prompt to save filter
                if appModel.viewState.showSavedPrereqsPrompt {
                    
                    prereqPrompt
                }
                
                // Dropdown content if prerequisite is selected
                if let type = selectedPrerequisite {
                    PrerequisiteDropdown(
                        appModel: appModel,
                        type: type,
                        sessionModel: sessionModel
                    ){
                        selectedPrerequisite = nil
                    }
                }
                
            }
            .background(Color(hex:"bef1fa"))
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
                            .frame(width: 90, height: 90)
                        
                        // Bravo's message bubble
                        ZStack(alignment: .center) {
                            RiveViewModel(fileName: "Message_Bubble").view()
                                .frame(width: 170, height: 90)

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

                            filtersToggleButton
                            
                            Spacer()
                            
                            
                            // TODO: Add more features here
                            ellipsesButton
                            
                            
                        }
                        
                        if appModel.viewState.showFilter {
                            
                            
                            // TODO: Replace old skills section with new SkillSelectionView
                            
                            // Skills for today view
                            SkillSelectionView(appModel: appModel, sessionModel: sessionModel)
                                .padding(.vertical, 3)
                            
                            
                            prerequisiteScrollView
                        }
                        
                        
                        // Dropdown content for saved filters
                        if appModel.viewState.showSavedPrereqs {
                            DisplaySavedFilters(
                                appModel: appModel,
                                sessionModel: sessionModel,
                                dismiss: { appModel.viewState.showSavedPrereqs = false }
                            )
                            .padding(.vertical, 3)
                        }
                        

                        
                        // Generated Drills Section
                        
                        GeneratedDrillsSection(appModel: appModel, sessionModel: sessionModel)
                    }
                    
                }
            }
            .transition(.move(edge: .bottom))
            .padding(.top, 20)

            }
            
                
            }
    }
    
    // MARK: Area behind home page
    private var areaBehindHomePage: some View {
        // Whole area behind the home page
        VStack {
            HStack {
                // back button to go back to home page
                if !appModel.viewState.showHomePage {
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
                        Image(systemName: "xmark")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    }
                }
                Spacer()

                
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
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
                                ForEach(sessionModel.orderedDrills) { drill in
                                    SmallDrillCard(
                                        appModel: appModel,
                                        sessionModel: sessionModel,
                                        drill: drill
                                    )
                                    .dropDestination(for: String.self) { items, location in
                                        guard let sourceTitle = items.first,
                                              let sourceIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == sourceTitle }),
                                              let destinationIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == drill.title }) else {
                                            return false
                                        }
                                        
                                        withAnimation(.spring()) {
                                            let drill = sessionModel.orderedDrills.remove(at: sourceIndex)
                                            sessionModel.orderedDrills.insert(drill, at: destinationIndex)
                                        }
                                        return true
                                    }
                                }
                            }
                            .padding()
                        }
                        
                    }
                    .transition(.move(edge: .bottom))
                    
                    
                }
                
        }
    }
    
    
    // MARK: Filter toggler
    private var filtersToggleButton: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.7)) {
                appModel.viewState.showFilter.toggle()
            }
        }) {
            HStack {
                Image("Filter_Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                if appModel.viewState.showFilter {
                    Image(systemName: "chevron.up")
                        .padding(.horizontal, 3)
                        .padding(.vertical, 3)
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.system(size: 16, weight: .medium))
                    
                } else {
                    Image(systemName: "chevron.down")
                        .padding(.horizontal, 3)
                        .padding(.vertical, 3)
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                        .font(.system(size: 16, weight: .medium))
                    
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(appModel.globalSettings.primaryGrayColor, lineWidth: 2)
            )
            
            
        }
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
    
    // MARK: Ellipses button
    private var ellipsesButton: some View {
        Button(action:  {
            if appModel.viewState.showSavedPrereqsPrompt == true {
                appModel.viewState.showSavedPrereqsPrompt = false
            } else {
                appModel.viewState.showSavedPrereqsPrompt = true
            }
        }) {
            VStack {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .padding()
                
            }
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(appModel.globalSettings.primaryGrayColor, lineWidth: 2)
            )
            
            
        }
        .padding(.top, 10)
        .padding(.horizontal, 15)
    }
    
    // MARK: Prerequisite Scroll View
    private var prerequisiteScrollView: some View{
        ZStack {
            
            Rectangle()
                .stroke(appModel.globalSettings.primaryGrayColor.opacity(0.3), lineWidth: 2)
                .frame(height: 70)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    
                    // Saved filters Button
                    Button(action: { withAnimation(.spring(dampingFraction: 0.7)) {
                        if appModel.viewState.showSavedPrereqs == true {
                            appModel.viewState.showSavedPrereqs = false
                        } else {
                            appModel.viewState.showSavedPrereqs = true
                        }
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
                            
                            Image(systemName: "heart")
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.vertical)
                    }
                    
                    
                    // Delete selected prereq button
                    Button(action: {
                        clearPrereqSelection()
                    }) {
                        ZStack {
                            Circle()
                                .fill(appModel.globalSettings.primaryLightGrayColor)
                                .frame(width: 40, height: 40)
                                .offset(x: 0, y: 3)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.vertical)
                        .padding(.trailing, 10)
                    }
                    
                    
                    
                    // All prereqs
                    ForEach(PrerequisiteType.allCases, id: \.self) { type in
                        PrerequisiteButton(
                            appModel: appModel,
                            type: type,
                            icon: icon(for: type),
                            isSelected: selectedPrerequisite == type,
                            value: prerequisiteValue(for: type)
                        ) {
                            if selectedPrerequisite == type {
                                selectedPrerequisite = nil
                            } else {
                                selectedPrerequisite = type
                            }
                        }
                        .padding(.vertical)
                    }
                    
                }
                .padding()
                
            }
            .frame(height: 50)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 18)

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
    }
    
    // MARK: Golden Button
    private var goldenButton: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.7)) {
                sessionModel.generateSession()
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
    private func prerequisiteValue(for type: PrerequisiteType) -> String {
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
    
    // Clears prereq selected options
    private func clearPrereqSelection() {
        sessionModel.selectedTime = nil
        sessionModel.selectedEquipment.removeAll()
        sessionModel.selectedTrainingStyle = nil
        sessionModel.selectedLocation = nil
        sessionModel.selectedDifficulty = nil
    }
    
    // structure for
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



// MARK: Prereq button
struct PrerequisiteButton: View {
    let appModel: MainAppModel
    let type: SessionGeneratorView.PrerequisiteType
    let icon: SessionGeneratorView.PrerequisiteIcon
    let isSelected: Bool
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack {
                icon.view
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(value.isEmpty ? Color(hex:"#f5cc9f") : Color(hex:"eb9c49"))
                    .stroke(value.isEmpty ? Color(hex:"f5cc9f") : Color(hex:"b37636"), lineWidth: 4)
            )
            .scaleEffect(isSelected ? 1.13 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isSelected)
        }
    }
}

// MARK: Prereq dropdown
struct PrerequisiteDropdown: View {
    let appModel: MainAppModel
    let type: SessionGeneratorView.PrerequisiteType
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismiss()
                }
            VStack(alignment: .leading, spacing: 12) {
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
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(optionsForType, id: \.self) { option in
                            Button(action: {
                                selectOption(option)
                                //                            dismiss()
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
                .frame(maxHeight: 150)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(15)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 3)
            )
        }
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

// MARK: Display Saved Filters

struct DisplaySavedFilters: View {
    let appModel: MainAppModel
    
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
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
            .frame(maxHeight: 150)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(15)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .stroke(Color.gray.opacity(0.3), lineWidth: 3)
        )
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
struct CompactDrillCard: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
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
        .sheet(isPresented: $showingDetail) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: drill)
        }
    }
}
// MARK: Drill card
struct DrillCard: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
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
        .sheet(isPresented: $showingDetail) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: drill)
        }
    }
}

// MARK: Small Drill card
struct SmallDrillCard: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    let drill: DrillModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 100, height: 50)
                Image(systemName: "figure.soccer")
                        .font(.system(size: 24))
                    .padding()
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
//                VStack(alignment: .leading) {
//                        Text(drill.title)
//                            .font(.custom("Poppins-Bold", size: 16))
//                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
//                }
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            DrillDetailView(appModel: appModel, sessionModel: sessionModel, drill: drill)
        }
    }
}




// MARK: Skill selection view
struct SkillSelectionView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var showingSkillSelector = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                Button(action: { showingSkillSelector = true }) {
                    RiveViewModel(fileName: "Plus_Button").view()
                        .frame(width: 50, height: 50)
                        .padding()
                }
                if sessionModel.orderedDrills.isEmpty {
                    RiveViewModel(fileName: "Arrow").view()
                        .frame(width: 40, height: 40)
                }
                // Horizontal scrolling selected skills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(sessionModel.selectedSkills).sorted(), id: \.self) { skill in
                            if let category = SessionGeneratorView.skillCategories.first(where: { $0.subSkills.contains(skill) }) {
                                SkillButton(
                                    appModel: appModel,
                                    title: skill,
                                    icon: category.icon,
                                    isSelected: true
                                ) { }
                            }
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
        .sheet(isPresented: $showingSkillSelector) {
            SkillSelectorSheet(appModel: appModel, selectedSkills: $sessionModel.selectedSkills)
        }
    }
}

// MARK: Skill button
struct SkillButton: View {
    let appModel: MainAppModel
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .padding(.bottom, 10)
                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                

                Text(title)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(height: 75)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
            .padding(.horizontal, 4)
        }
    }
}


// MARK: Skill selector sheet
struct SkillSelectorSheet: View {
    let appModel: MainAppModel
    @Binding var selectedSkills: Set<String>
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
                    Button("Done") {
                        dismiss()
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
                                                if selectedSkills.contains(subSkill) {
                                                    selectedSkills.remove(subSkill)
                                                } else {
                                                    selectedSkills.insert(subSkill)
                                                }
                                            }) {
                                                HStack {
                                                    Text(subSkill)
                                                        .font(.custom("Poppins-Medium", size: 16))
                                                    Spacer()
                                                    if selectedSkills.contains(subSkill) {
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
    }
    // TODO: move this somewhere else?
    // Highlight category if sub skill selected
    func isCategorySelected(_ category: SkillCategory) -> Bool {
        for skill in category.subSkills {
            if selectedSkills.contains(skill) {
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
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var viewState = MainAppModel.ViewState()
    
    var body: some View {
        ScrollView {
        VStack(alignment: .center, spacing: 12) {
            HStack {
                Rectangle()
                    .fill(appModel.globalSettings.primaryLightGrayColor)
                    .frame(width:120, height: 2)
                
                Spacer()
                
                
                Text("Session")
                    .font(.custom("Poppins-Bold", size: 20))
                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                
                
                Spacer()
                
                Rectangle()
                    .fill(appModel.globalSettings.primaryLightGrayColor)
                    .frame(width:120, height: 2)
            }
            
            // Button for adding drills
            HStack {
                Button(action: {
                    viewState.showSearchDrills = true
                }) {
                    ZStack {
                        Circle()
                            .fill(appModel.globalSettings.primaryLightGrayColor)
                            .frame(width: 30, height: 30)
                            .offset(x: 0, y: 3)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: "plus")
                            .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .disabled(sessionModel.orderedDrills.isEmpty)
                .opacity(sessionModel.orderedDrills.isEmpty ? 0.4 : 1.0)
                
                Spacer()
                
            }
            
            // Drills view
            
            
                
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
                    
                    ForEach(sessionModel.orderedDrills) { drill in
                        DrillCard(
                            appModel: appModel,
                            sessionModel: sessionModel,
                            drill: drill
                        )
                        .draggable(drill.title) {
                            DrillCard(
                                appModel: appModel,
                                sessionModel: sessionModel,
                                drill: drill
                            )
                        }
                        .dropDestination(for: String.self) { items, location in
                            guard let sourceTitle = items.first,
                                  let sourceIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == sourceTitle }),
                                  let destinationIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == drill.title }) else {
                                return false
                            }
                            
                            withAnimation(.spring()) {
                                let drill = sessionModel.orderedDrills.remove(at: sourceIndex)
                                sessionModel.orderedDrills.insert(drill, at: destinationIndex)
                            }
                            return true
                        }
                    }
                    
                }
            }
            
        }
        .padding()
        .cornerRadius(15)
        .sheet(isPresented: $viewState.showSearchDrills) {
            SearchDrillsSheetView(appModel: appModel, sessionModel: sessionModel, dismiss: { viewState.showSearchDrills = false })
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
