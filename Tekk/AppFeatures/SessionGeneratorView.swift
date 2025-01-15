//
//  SessionGeneratorView.swift
//  BravoBall
//
//  Created by Jordan on 1/7/25.
//

import SwiftUI
import RiveRuntime

struct SessionGeneratorView: View {
    @ObservedObject var model: OnboardingModel
    @StateObject private var sessionModel: SessionGeneratorModel
    @State private var showingDrills = false
    @State private var selectedPrerequisite: PrerequisiteType?
    
    init(model: OnboardingModel) {
        self.model = model
        _sessionModel = StateObject(wrappedValue: SessionGeneratorModel(onboardingData: model.onboardingData))
    }
    
    enum PrerequisiteType: String, CaseIterable {
        case time = "Time"
        case equipment = "Equipment"
        case trainingStyle = "Training Style"
        case location = "Location"
        case difficulty = "Difficulty"
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    // Top Bar with Controls
                    HStack(spacing: 12) {
                        Button(action: { /* Close action */ }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .medium))
                        }
                        
                        Spacer()
                        
                        Button(action: { /* More options */ }) {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                                .font(.system(size: 20, weight: .medium))
                        }
                    }
                    .padding()
                    
                    // Prerequisites ScrollView
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(PrerequisiteType.allCases, id: \.self) { type in
                                PrerequisiteButton(
                                    type: type,
                                    isSelected: selectedPrerequisite == type,
                                    value: prerequisiteValue(for: type)
                                ) {
                                    if selectedPrerequisite == type {
                                        selectedPrerequisite = nil
                                    } else {
                                        selectedPrerequisite = type
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 60)
                    
                    // Dropdown content if prerequisite is selected
                    if let type = selectedPrerequisite {
                        PrerequisiteDropdown(type: type, sessionModel: sessionModel) {
                            selectedPrerequisite = nil
                        }
                        .transition(.move(edge: .top))
                    }
                    
            ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                    // Skills Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Skills for Today")
                                            .font(.custom("Poppins-Bold", size: 16))
                            Spacer()
                                        Button(action: { /* Add skill */ }) {
                                Image(systemName: "plus")
                                    .foregroundColor(model.globalSettings.primaryYellowColor)
                            }
                        }
                        
                        // Skills Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(model.questionOptions[6], id: \.self) { skill in
                                SkillButton(
                                    title: skill,
                                    isSelected: sessionModel.selectedSkills.contains(skill),
                                    action: {
                                        if sessionModel.selectedSkills.contains(skill) {
                                            sessionModel.selectedSkills.remove(skill)
                                        } else {
                                            sessionModel.selectedSkills.insert(skill)
                                        }
                                        showingDrills = !sessionModel.selectedSkills.isEmpty
                                        sessionModel.updateDrills() // Update the drills when skills change
                                    }
                                )
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    
                    if showingDrills {
                    // Generated Drills Section
                        VStack(alignment: .leading, spacing: 16) {
                        HStack {
                                RiveViewModel(fileName: "Bravo_Panting").view()
                                    .frame(width: 80, height: 80)
                                        
                                    Text("Looks like you got \(sessionModel.orderedDrills.count) drills for today!")
                                        .font(.custom("Poppins-Bold", size: 16))
                                    }
                                    
                                    // Drill Cards with drag-drop support
                                    ForEach(sessionModel.orderedDrills) { drill in
                                        DrillCard(drill: drill)
                                            // Make the card draggable using the title as the transfer data
                                            .draggable(drill.title) {
                                                // This closure provides the visual preview while dragging
                                                DrillCard(drill: drill)
                                            }
                                            // Make each card a drop destination for other cards
                                            .dropDestination(for: String.self) { items, location in
                                                // Get the source and destination indices for reordering
                                                guard let sourceTitle = items.first,
                                                      let sourceIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == sourceTitle }),
                                                      let destinationIndex = sessionModel.orderedDrills.firstIndex(where: { $0.title == drill.title }) else {
                                                    return false
                                                }
                                                
                                                // Perform the reordering with animation
                                                withAnimation(.spring()) {
                                                    let drill = sessionModel.orderedDrills.remove(at: sourceIndex)
                                                    sessionModel.orderedDrills.insert(drill, at: destinationIndex)
                                                }
                                                return true
                                            }
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                        // Add bottom padding to account for the fixed Start Session button
                        .padding(.bottom, 80)
                    }
                }
                
                // Fixed Start Session Button
                if showingDrills {
                            Button(action: {
                        sessionModel.generateSession()
                            }) {
                                Text("Start Session")
                        .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(model.globalSettings.primaryYellowColor)
                                    .cornerRadius(25)
                            }
                    .padding(.horizontal)
                    .padding(.bottom, 8) // Add padding to lift above tab bar
                }
            }
        }
    }
    
    private func prerequisiteValue(for type: PrerequisiteType) -> String {
        switch type {
        case .time: return sessionModel.selectedTime
        case .equipment: return "\(sessionModel.selectedEquipment.count) selected"
        case .trainingStyle: return sessionModel.selectedTrainingStyle
        case .location: return sessionModel.selectedLocation
        case .difficulty: return sessionModel.selectedDifficulty
        }
    }
}

struct PrerequisiteButton: View {
    let type: SessionGeneratorView.PrerequisiteType
    let isSelected: Bool
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(type.rawValue)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundColor(.gray)
                HStack {
                    Text(value.isEmpty ? "Select" : value)
                        .font(.custom("Poppins-SemiBold", size: 14))
                    Image(systemName: "chevron.down")
                        .font(.custom("Poppins-SemiBold", size: 12))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
        .foregroundColor(isSelected ? .yellow : .black)
    }
}

struct PrerequisiteDropdown: View {
    let type: SessionGeneratorView.PrerequisiteType
    @ObservedObject var sessionModel: SessionGeneratorModel
    let dismiss: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(type.rawValue)
                    .font(.custom("Poppins-Bold", size: 16))
                Spacer()
                Button(action: dismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(optionsForType, id: \.self) { option in
                        Button(action: {
                            selectOption(option)
                            dismiss()
                        }) {
                            HStack {
                                Text(option)
                                    .font(.custom("Poppins-Regular", size: 14))
                                    .foregroundColor(.black)
                                Spacer()
                                if isSelected(option) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        Divider()
                    }
                }
            }
            .frame(maxHeight: 200)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 5)
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
            sessionModel.selectedTime = option
        case .equipment:
            if sessionModel.selectedEquipment.contains(option) {
                sessionModel.selectedEquipment.remove(option)
            } else {
                sessionModel.selectedEquipment.insert(option)
            }
        case .trainingStyle:
            sessionModel.selectedTrainingStyle = option
        case .location:
            sessionModel.selectedLocation = option
        case .difficulty:
            sessionModel.selectedDifficulty = option
        }
    }
}

struct SkillButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "figure.soccer")
                    .font(.system(size: 14))
                Text(title)
                    .font(.custom("Poppins-Medium", size: 14))
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .foregroundColor(isSelected ? .yellow : .gray)
    }
}

struct DrillCard: View {
    let drill: DrillModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack {
                // Drag handle
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding(.trailing, 8)
                
                Image(systemName: "figure.soccer")
                    .font(.system(size: 24))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading) {
                    Text(drill.title)
                        .font(.custom("Poppins-Bold", size: 16))
                    Text("\(drill.sets) sets - \(drill.reps) reps - \(drill.duration)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            DrillDetailView(drill: drill)
        }
    }
}




class SessionGeneratorModel: ObservableObject {
    @Published var selectedTime: String = "1h"
    @Published var selectedEquipment: Set<String> = []
    @Published var selectedTrainingStyle: String = "medium intensity"
    @Published var selectedLocation: String = ""
    @Published var selectedDifficulty: String = ""
    @Published var selectedSkills: Set<String> = []
    @Published var orderedDrills: [DrillModel] = []
    
    // Prerequisite options
    let timeOptions = ["15min", "30min", "45min", "1h", "1h30", "2h+"]
    let equipmentOptions = ["balls", "cones", "goals"]
    let trainingStyleOptions = ["medium intensity", "high intensity", "game prep", "game recovery", "rest day"]
    let locationOptions = ["field with goals", "small field", "indoor court"]
    let difficultyOptions = ["beginner", "intermediate", "advanced"]
    
    // Test data for drills
    static let testDrills: [DrillModel] = [
        DrillModel(
            title: "Passing Drill",
            sets: "4",
            reps: "10",
            duration: "15min",
            description: "Improve your passing accuracy with this focused drill.",
            tips: ["Keep your head up", "Follow through", "Use inside of foot"],
            equipment: ["Soccer ball", "Cones"]
        ),
        DrillModel(
            title: "Shooting Drill",
            sets: "3",
            reps: "5",
            duration: "20min",
            description: "Perfect your shooting technique with power and accuracy.",
            tips: ["Plant foot beside ball", "Strike with laces", "Follow through"],
            equipment: ["Soccer ball", "Goal"]
        ),
        DrillModel(
            title: "Dribbling Drill",
            sets: "4",
            reps: "8",
            duration: "15min",
            description: "Master close ball control and quick direction changes.",
            tips: ["Keep ball close", "Use both feet", "Look up regularly"],
            equipment: ["Soccer ball", "Cones"]
        )
    ]
    
    // Initialize with user's onboarding data
    init(onboardingData: OnboardingModel.OnboardingData) {
        // Set initial values based on onboarding data
        selectedDifficulty = onboardingData.trainingExperience.lowercased()
        if let location = onboardingData.trainingLocation.first {
            selectedLocation = location
        }
        selectedEquipment = Set(onboardingData.availableEquipment)
        
        // Convert daily training time to our format
        switch onboardingData.dailyTrainingTime {
        case "Less than 15 minutes": selectedTime = "15min"
        case "15-30 minutes": selectedTime = "30min"
        case "30-60 minutes": selectedTime = "1h"
        case "1-2 hours": selectedTime = "1h30"
        case "More than 2 hours": selectedTime = "2h+"
        default: selectedTime = "1h"
        }
        
        // Initialize with test drills
        orderedDrills = Self.testDrills
    }
    
    // Update drills when skills are selected
    func updateDrills() {
        // For testing, we'll keep the test drills regardless of selection
        // In production, this would filter based on selected skills
        if !orderedDrills.isEmpty { return }
        orderedDrills = Self.testDrills
    }
    
    // Move drill from one position to another
    func moveDrill(from source: IndexSet, to destination: Int) {
        orderedDrills.move(fromOffsets: source, toOffset: destination)
    }
    
    // Generate new session based on current prerequisites
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
