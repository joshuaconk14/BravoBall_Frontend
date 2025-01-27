//
//  testSesGenView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 1/22/25.
//

//
//  SessionGeneratorView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime

struct testSesGenView: View {
    @ObservedObject var model: OnboardingModel
    @ObservedObject var appModel: MainAppModel
    @StateObject private var sessionModel: SessionGeneratorModel
    @State private var showingDrills = false
    @State private var selectedPrerequisite: PrerequisiteType?
    @State private var showFilter: Bool = true
    @State private var showHomePage: Bool = true
    @State private var showTextBubble: Bool = true
    @State private var showSmallDrillCards: Bool = false
    @State private var showSavedPrereqsPrompt: Bool = true
    
    init(model: OnboardingModel, appModel: MainAppModel) {
        self.model = model
        self.appModel = appModel
        _sessionModel = StateObject(wrappedValue: SessionGeneratorModel(onboardingData: model.onboardingData))
    }

    
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
        NavigationView {
            ZStack(alignment: .bottom) {
                
                
                
                
                ZStack(alignment: .top) {
                        // Top Bar with Controls
//                            HStack(spacing: 20) {
//                                Spacer()
//                                                            
//                                HStack {
//                                    Image("Streak_Flame")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 30, height: 30)
//                                    Text("\(appModel.currentStreak)")
//                                        .font(.custom("Poppins-Bold", size: 30))
//                                        .foregroundColor(Color(hex: "#ff7b24"))
//                                }
//                                
//                                Button(action: { /* More options */ }) {
//                                    Image(systemName: "ellipsis")
//                                        .foregroundColor(.black)
//                                        .font(.system(size: 20, weight: .medium))
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.vertical, 8)
                
                    

                    // Bravo's area
                    VStack {
                        HStack {
                            if !showHomePage {
                                Button(action:  {
                                    withAnimation(.spring(dampingFraction: 0.7)) {
                                        showSmallDrillCards = false
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                        withAnimation(.spring(dampingFraction: 0.7)) {
                                            showHomePage = true
                                            showTextBubble = true
                                        }
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                }
                            }
                            Spacer()
                            

                            RiveViewModel(fileName: "Bravo_Panting").view()
                                .frame(width: 90, height: 90)
                            
                            
                            // Text bubble
                            if showTextBubble {
                                ZStack(alignment: .center) {
                                    RiveViewModel(fileName: "Message_Bubble").view()
                                        .frame(width: 170, height: 90)

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
                            
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        
                        Spacer()

                            // When the session is activated
                            if showSmallDrillCards {
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
                        
                        
                        
                    // Everything below bravo's space
                    if showHomePage {
                        
                        // ZStack for rounded corner
                        ZStack {
                            
                            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                                .fill(Color.white)
                                .edgesIgnoringSafeArea(.bottom)
                            
                            
                            VStack(alignment: .leading, spacing: 12) {
                                
                                if showFilter {
                                    // TODO: Replace old skills section with new SkillSelectionView
                                    
                                    // Skills for today view
                                    SkillSelectionView(appModel: appModel, sessionModel: sessionModel)
                                        .padding(.vertical, 3)
                                    
                                    
                                    
                                    // Prerequisites ScrollView
                                    ZStack {
                                        
                                        Rectangle()
                                            .stroke(appModel.globalSettings.primaryGrayColor.opacity(0.3), lineWidth: 2)
                                            .frame(height: 80)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                
                                                // Saved filters Button
                                                Button(action: {
                                                    showSavedPrereqsPrompt = true
                                                    
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
                                }
                                
                                // TODO: fix toggle animation
                                // Filters toggle button
                                Button(action: {
                                    withAnimation(.spring(dampingFraction: 0.7)) {
                                        showFilter.toggle()
                                    }
                                }) {
                                    HStack {
                                        Image("Filter_Icon")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        if showFilter {
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
                                
                                
                                
                                
                                // Dropdown content if prerequisite is selected
                                if let type = selectedPrerequisite {
                                    PrerequisiteDropdown(
                                        appModel: appModel,
                                        type: type,
                                        sessionModel: sessionModel
                                    ){
                                        selectedPrerequisite = nil
                                    }
                                    .padding(.horizontal, 50)
                                }
                                
                                // Generated Drills Section
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
                                    
                                    // Buttons for session adjustment
                                    HStack {
                                        Button(action: { /* Close action */ }) {
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
                                        Button(action: { /* Close action */ }) {
                                            ZStack {
                                                Circle()
                                                    .fill(appModel.globalSettings.primaryLightGrayColor)
                                                    .frame(width: 30, height: 30)
                                                    .offset(x: 0, y: 3)
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 30, height: 30)
                                                
                                                Image(systemName: "chevron.down")
                                                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                                                    .font(.system(size: 16, weight: .medium))
                                            }
                                        }
                                        Spacer()
                                        
                                    }
                                    
                                    // Drills view
                                    
                                    ScrollView {
                                        
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
                                                    drill: drill
                                                )
                                                .draggable(drill.title) {
                                                    DrillCard(
                                                        appModel: appModel,
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
                            }
                        }
                        .transition(.move(edge: .bottom))
                        .padding(.top, 120)


                    }
                    
                        
                    }
                
                // MARK: here
                // TODO: create structure that saves saved filters
                if showSavedPrereqsPrompt {
//                    ZStack(alignment: .top) {
//                        Rectangle()
//                            .fill(Color.white)
//                        
//                            .frame(width: 300, height: 100)
//                            .padding()
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(appModel.globalSettings.primaryLightGrayColor,
//                                            lineWidth: 2)
//                            )
//                        VStack {
//                            HStack {
//                                Button(action: {
//                                    showSavedPrereqsPrompt = false
//                                }) {
//                                    Image(systemName: "xmark")
//                                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
//                                        .font(.system(size: 16, weight: .medium))
//                                        .padding(.leading, 7)
//                                    
//                                }
//                                
//                                Spacer()
//                                
//                                Text("Save filter")
//                                    .font(.custom("Poppins-Bold", size: 12))
//                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
//                                Spacer()
//                            }
//                            .padding()
//                            
//                            TextField("Name", text: $savedFiltersName)
//                                .padding()
//                                .disableAutocorrection(true)
//                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
//                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(appModel.globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1))
//                                .keyboardType(.default)
//                            Button(action: {
//                                showSavedPrereqsPrompt = false
//                            }) {
//                                Text("Save")
//                                    .font(.custom("Poppins-Bold", size: 12))
//                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
//                                
//                            }
//                        }
//                        
//                    }
                }

                
                    
                if !sessionModel.orderedDrills.isEmpty {
                    if showHomePage {
                        Button(action: {
                            withAnimation(.spring(dampingFraction: 0.7)) {
                                sessionModel.generateSession()
                                showHomePage = false
                                showTextBubble = false
                            }
                            
                            // Delay the appearance of drill cards to match the menu's exit animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation(.spring(dampingFraction: 0.7)) {
                                    showSmallDrillCards = true
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
                        .padding(.bottom, 50)
                        .transition(.move(edge: .bottom))
                    }
                }
                
            }
//            .animation(.spring(dampingFraction: 0.7), value: showHomePage)
            .background(Color(hex:"bef1fa"))
        }
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
}

// MARK: Prereq button
struct PrerequisiteButton: View {
    let appModel: MainAppModel
    let type: testSesGenView.PrerequisiteType
    let icon: testSesGenView.PrerequisiteIcon
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
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(value.isEmpty ? Color(hex:"#f5cc9f") : Color(hex:"eb9c49"))
//                    .stroke(isSelected ? Color.blue : Color(hex:"b37636"), lineWidth: 4)
                    .stroke(value.isEmpty ? Color(hex:"f5cc9f") : Color(hex:"b37636"), lineWidth: 4)
            )
        }
    }
}

// MARK: Prereq dropdown
struct PrerequisiteDropdown: View {
    let appModel: MainAppModel
    let type: testSesGenView.PrerequisiteType
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    
    var body: some View {
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

//// MARK: Saved Prereqs Prompt
//struct SavedPrereqsPrompt: View {
//    let appModel: MainAppModel
//    
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.white)
//                .frame(width:80, height: 60)
//            Button(action: {
//                showSavedPrereqsPrompt = false
//            }) {
//                ZStack {
//                    Circle()
//                        .fill(appModel.globalSettings.primaryLightGrayColor)
//                        .frame(width: 40, height: 40)
//                        .offset(x: 0, y: 3)
//                    Circle()
//                        .fill(Color.white)
//                        .frame(width: 40, height: 40)
//                    
//                    Image(systemName: "xmark")
//                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
//                        .font(.system(size: 16, weight: .medium))
//                }
//                .padding(.vertical)
//                .padding(.trailing, 10)
//            }
//            
//        }
//    }
//}

// MARK: Compact Drill card
struct CompactDrillCard: View {
    let appModel: MainAppModel
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
            DrillDetailView(drill: drill)
        }
    }
}
// MARK: Drill card
struct DrillCard: View {
    let appModel: MainAppModel
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
            DrillDetailView(drill: drill)
        }
    }
}

// MARK: Small Drill card
struct SmallDrillCard: View {
    let appModel: MainAppModel
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
            DrillDetailView(drill: drill)
        }
    }
}



// MARK: Session model
class SessionGeneratorModel: ObservableObject {
    @Published var selectedTime: String?
    @Published var selectedEquipment: Set<String> = []
    @Published var selectedTrainingStyle: String?
    @Published var selectedLocation: String?
    @Published var selectedDifficulty: String?
    @Published var selectedSkills: Set<String> = [] {
        didSet {
            updateDrills()
        }
    }
    @Published var orderedDrills: [DrillModel] = []
    
    // Prerequisite options
    let timeOptions = ["15min", "30min", "45min", "1h", "1h30", "2h+"]
    let equipmentOptions = ["balls", "cones", "goals"]
    let trainingStyleOptions = ["medium intensity", "high intensity", "game prep", "game recovery", "rest day"]
    let locationOptions = ["field with goals", "small field", "indoor court"]
    let difficultyOptions = ["beginner", "intermediate", "advanced"]
    
    // Test data for drills with specific sub-skills
    static let testDrills: [DrillModel] = [
        DrillModel(
            title: "Short Passing Drill",
            sets: "4",
            reps: "10",
            duration: "15min",
            description: "Practice accurate short passes with a partner or wall.",
            tips: ["Keep the ball on the ground", "Use inside of foot", "Follow through towards target"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Long Passing Practice",
            sets: "3",
            reps: "8",
            duration: "20min",
            description: "Improve your long-range passing accuracy.",
            tips: ["Lock ankle", "Follow through", "Watch ball contact"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Through Ball Training",
            sets: "4",
            reps: "6",
            duration: "15min",
            description: "Practice timing and weight of through passes.",
            tips: ["Look for space", "Time the pass", "Weight it properly"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Power Shot Practice",
            sets: "3",
            reps: "5",
            duration: "20min",
            description: "Work on powerful shots on goal.",
            tips: ["Plant foot beside ball", "Strike with laces", "Follow through"],
            equipment: ["Soccer ball", "Goal"]
        ),
        DrillModel(
            title: "1v1 Dribbling Skills",
            sets: "4",
            reps: "8",
            duration: "15min",
            description: "Master close ball control and quick direction changes.",
            tips: ["Keep ball close", "Use both feet", "Change pace"],
            equipment: ["Soccer ball", "Cones"]
        )
    ]
    
    // Initialize with user's onboarding data
    init(onboardingData: OnboardingModel.OnboardingData) {
        selectedDifficulty = onboardingData.trainingExperience.lowercased()
        if let location = onboardingData.trainingLocation.first {
            selectedLocation = location
        }
        selectedEquipment = Set(onboardingData.availableEquipment)
        
        switch onboardingData.dailyTrainingTime {
        case "Less than 15 minutes": selectedTime = "15min"
        case "15-30 minutes": selectedTime = "30min"
        case "30-60 minutes": selectedTime = "1h"
        case "1-2 hours": selectedTime = "1h30"
        case "More than 2 hours": selectedTime = "2h+"
        default: selectedTime = "1h"
        }
    }
    
    // Update drills based on selected sub-skills
    func updateDrills() {
        if selectedSkills.isEmpty {
            orderedDrills = []
            return
        }
        
        // Show drills that match any of the selected sub-skills
        orderedDrills = Self.testDrills.filter { drill in
            // Check if any of the selected skills match the drill
            for skill in selectedSkills {
                // Match drills based on skill keywords
                switch skill.lowercased() {
                case "short passing":
                    if drill.title.contains("Short Passing") { return true }
                case "long passing":
                    if drill.title.contains("Long Passing") { return true }
                case "through balls":
                    if drill.title.contains("Through Ball") { return true }
                case "power shots", "finesse shots", "volleys", "one-on-one finishing", "long shots":
                    if drill.title.contains("Shot") || drill.title.contains("Shooting") { return true }
                case "close control", "speed dribbling", "1v1 moves", "winger skills", "ball mastery":
                    if drill.title.contains("Dribbling") || drill.title.contains("1v1") { return true }
                default:
                    // For any other skills, try to match based on the first word
                    let mainSkill = skill.split(separator: " ").first?.lowercased() ?? ""
                    if drill.title.lowercased().contains(mainSkill) { return true }
                }
            }
            return false
        }
    }
    
    func moveDrill(from source: IndexSet, to destination: Int) {
        orderedDrills.move(fromOffsets: source, toOffset: destination)
    }
    
    func generateSession() {
        // TODO: Implement session generation logic
    }
}

// Update DrillModel to be identifiable
struct DrillModel: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let sets: String
    let reps: String
    let duration: String
    let description: String
    let tips: [String]
    let equipment: [String]
    
    static func == (lhs: DrillModel, rhs: DrillModel) -> Bool {
        lhs.id == rhs.id
    }
}

struct SkillCategory {
    let name: String
    let subSkills: [String]
    let icon: String
}

extension testSesGenView {
    // Define all available skill categories and their sub-skills
    static let skillCategories: [SkillCategory] = [
        SkillCategory(name: "Passing", subSkills: [
            "Short passing",
            "Long passing",
            "Through balls",
            "First-time passing",
            "Wall passing"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Shooting", subSkills: [
            "Power shots",
            "Finesse shots",
            "Volleys",
            "One-on-one finishing",
            "Long shots"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Dribbling", subSkills: [
            "Close control",
            "Speed dribbling",
            "1v1 moves",
            "Winger skills",
            "Ball mastery"
        ], icon: "figure.walk"),
        
        SkillCategory(name: "First Touch", subSkills: [
            "Ground control",
            "Aerial control",
            "Turn with ball",
            "Receiving under pressure",
            "One-touch control"
        ], icon: "figure.stand"),
        
        SkillCategory(name: "Defending", subSkills: [
            "1v1 defending",
            "Tackling",
            "Positioning",
            "Intercepting",
            "Pressing"
        ], icon: "figure.soccer"),
        
        SkillCategory(name: "Fitness", subSkills: [
            "Speed",
            "Agility",
            "Endurance",
            "Strength",
            "Recovery"
        ], icon: "figure.run")
    ]
}


// MARK: Skill selection view
struct SkillSelectionView: View {
    let appModel: MainAppModel
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var showingSkillSelector = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Rectangle()
//                    .fill(appModel.globalSettings.primaryLightGrayColor)
//                    .frame(width:80, height: 2)
//                
//
//                Spacer()
//                
//                Text("Skills for Today")
//                    .font(.custom("Poppins-Bold", size: 20))
//                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
//
//                Spacer()
//                
//                Rectangle()
//                    .fill(appModel.globalSettings.primaryLightGrayColor)
//                    .frame(width:80, height: 2)
//            }
            
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
                            if let category = testSesGenView.skillCategories.first(where: { $0.subSkills.contains(skill) }) {
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
        NavigationView {
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
                        ForEach(testSesGenView.skillCategories, id: \.name) { category in
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
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 4)
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


// MARK: Preview
#Preview {
    let mockOnboardingModel = OnboardingModel()
    let mockAppModel = MainAppModel()
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
    return
        testSesGenView(model: mockOnboardingModel, appModel: mockAppModel)
}
