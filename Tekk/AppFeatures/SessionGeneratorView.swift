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
                        .padding(.horizontal)
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
                                        .font(.headline)
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
                                        
                                        Text("Looks like you got \(sessionModel.selectedSkills.count) drills for today!")
                                            .font(.headline)
                                    }
                                    
                                    // Drill Cards
                                    ForEach(Array(sessionModel.selectedSkills), id: \.self) { skill in
                                        DrillCard(title: "\(skill) Drill", duration: "20min", sets: "4", reps: "2")
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
                            .font(.headline)
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
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                HStack {
                    Text(value.isEmpty ? "Select" : value)
                        .font(.system(size: 14, weight: .semibold))
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
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
                    .font(.headline)
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
                    .font(.system(size: 14, weight: .medium))
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
    let title: String
    let duration: String
    let sets: String
    let reps: String
    
    var body: some View {
        HStack {
            Image(systemName: "figure.soccer")
                .font(.system(size: 24))
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text("\(sets) sets - \(reps) reps - \(duration)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: { /* More options */ }) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
    }
}




class SessionGeneratorModel: ObservableObject {
    @Published var selectedTime: String = "1h"
    @Published var selectedEquipment: Set<String> = []
    @Published var selectedTrainingStyle: String = "medium intensity"
    @Published var selectedLocation: String = ""
    @Published var selectedDifficulty: String = ""
    @Published var selectedSkills: Set<String> = []
    
    // Prerequisite options
    let timeOptions = [
        "15min", "30min", "45min", "1h", "1h30", "2h+"
    ]
    
    let equipmentOptions = [
        "balls", "cones", "goals"
    ]
    
    let trainingStyleOptions = [
        "medium intensity",
        "high intensity",
        "game prep",
        "game recovery",
        "rest day"
    ]
    
    let locationOptions = [
        "field with goals",
        "small field",
        "indoor court"
    ]
    
    let difficultyOptions = [
        "beginner",
        "intermediate",
        "advanced"
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
    }
    
    // Generate new session based on current prerequisites
    func generateSession() {
        // TODO: Implement session generation logic
    }
}
