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
    @ObservedObject var appModel: MainAppModel
    @StateObject private var sessionModel: SessionGeneratorModel
    @State private var showingDrills = false
    @State private var selectedPrerequisite: PrerequisiteType?
    
    init(model: OnboardingModel, appModel: MainAppModel) {
        self.model = model
        self.appModel = appModel
        _sessionModel = StateObject(wrappedValue: SessionGeneratorModel(onboardingData: model.onboardingData))
    }
    
    // Filter types
    enum PrerequisiteType: String, CaseIterable {
        case time = "Time"
        case equipment = "Equipment"
        case trainingStyle = "Training Style"
        case location = "Location"
        case difficulty = "Difficulty"
    }
    
    // MARK: Nav bar addition
    var body: some View {
        NavigationView {
            content
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        // Top Bar with Controls
                        HStack(spacing: 12) {
                            Spacer()
                            
                            HStack {
                                Image("Streak_Flame")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                Text("\(appModel.currentStreak)")
                                    .font(.custom("Poppins-Bold", size: 30))
                                    .foregroundColor(appModel.globalSettings.primaryDarkColor)
                            }
                            
                            Button(action: { /* More options */ }) {
                                Image(systemName: "ellipsis")
                                    .foregroundColor(.black)
                                    .font(.system(size: 20, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }
                .toolbarBackground(appModel.globalSettings.primaryLightestGrayColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    // MARK: Main view
    var content: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Prerequisites ScrollView
                    if sessionModel.orderedDrills.isEmpty {
                        HStack {
                            RiveViewModel(fileName: "Bravo_Panting").view()
                                .frame(width: 90, height: 90)
                            Text("Choose your skill to improve today")
                                .font(.custom("Poppins-Bold", size: 12))
                        }
                        .padding()
                    }
//                    } else {
//                        HStack {
//                            RiveViewModel(fileName: "Bravo_Panting").view()
//                                .frame(width: 90, height: 90)
//                            Text("Looks like you got \(sessionModel.orderedDrills.count) drills for today!")
//                                .font(.custom("Poppins-Bold", size: 12))
//                    }
                        
                        
                    // Scrollview for the filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            Button(action: { /* Close action */ }) {
                                ZStack {
                                    Circle()
                                        .fill(appModel.globalSettings.primaryLightGrayColor)
                                        .frame(width: 30, height: 30)
                                        .offset(x: 0, y: 3)
                                    Circle()
                                        .fill(appModel.globalSettings.primaryLightestGrayColor)
                                        .frame(width: 30, height: 30)
                                        
                                    Image(systemName: "xmark")
                                        .foregroundColor(.black)
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            ForEach(PrerequisiteType.allCases, id: \.self) { type in
                                PrerequisiteButton(
                                    appModel: appModel,
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
                    .frame(height: 50)
                    
                    // Dropdown content if prerequisite is selected
                    if let type = selectedPrerequisite {
                        PrerequisiteDropdown(appModel: appModel, type: type, sessionModel: sessionModel) {
                            selectedPrerequisite = nil
                        }
                        .transition(.move(edge: .top))
                    }
                    
                     // Skills for today view
                    VStack(alignment: .leading, spacing: 12) {
                        // Replace old skills section with new SkillSelectionView
                        SkillSelectionView(sessionModel: sessionModel)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(15)

                    
                            if !sessionModel.orderedDrills.isEmpty {
                                // Generated Drills Section
                                    VStack(alignment: .leading, spacing: 12) {
                                    
                                    ForEach(sessionModel.orderedDrills) { drill in
                                        DrillCard(drill: drill)
                                            .draggable(drill.title) {
                                                DrillCard(drill: drill)
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
                                .padding()
                                .background(Color.white)
                                .cornerRadius(15)
                            }
                        }
                        .padding()
                        .padding(.bottom, 80)
                    }
            }
            
            if !sessionModel.orderedDrills.isEmpty {
                        Button(action: {
                    sessionModel.generateSession()
                        }) {
                            ZStack {
                                RiveViewModel(fileName: "Golden_Button").view()
                                    .frame(width: 330, height: 180)
                            
                                Text("Start Session")
                                    .font(.custom("Poppins-Bold", size: 22))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal)
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

// MARK: Prereq button
struct PrerequisiteButton: View {
    let appModel: MainAppModel
    let type: SessionGeneratorView.PrerequisiteType
    let isSelected: Bool
    let value: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
                HStack {
                    Text(value.isEmpty ? "Select" : value)
                        .font(.custom("Poppins-Bold", size: 14))
                        .foregroundColor(appModel.globalSettings.primaryDarkColor)
                    Image(systemName: "chevron.down")
                        .font(.custom("Poppins-Bold", size: 12))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.yellow : Color.gray.opacity(0.3), lineWidth: 2)
                )
        }
        .foregroundColor(isSelected ? .yellow : .black)
    }
}

// MARK: Prereq dropdown
struct PrerequisiteDropdown: View {
    let appModel: MainAppModel
    let type: SessionGeneratorView.PrerequisiteType
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
                                    .font(.custom("Poppins-Bold", size: 14))
                                    .foregroundColor(appModel.globalSettings.primaryGrayColor)
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

// MARK: Old Skill button
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
                    .font(.custom("Poppins-Bold", size: 14))
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

// MARK: Drill card
struct DrillCard: View {
    let drill: DrillModel
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            ZStack {
                RiveViewModel(fileName: "Drill_Card_Incomplete").view()
                    .frame(width: 300, height: 150)
                HStack {
                        // Drag handle
                        Image(systemName: "line.3.horizontal")
                            .padding()
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
                            .font(.custom("Poppins-Bold", size: 14))
                            .foregroundColor(.gray)
                    }
                
                Spacer()
                
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(.gray)
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

// MARK: Session generator
class SessionGeneratorModel: ObservableObject {
    @Published var selectedTime: String = "1h"
    @Published var selectedEquipment: Set<String> = []
    @Published var selectedTrainingStyle: String = "medium intensity"
    @Published var selectedLocation: String = ""
    @Published var selectedDifficulty: String = ""
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

// MARK: Drill Model
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

// MARK: Skill Category Model
struct SkillCategory {
    let name: String
    let subSkills: [String]
    let icon: String
}

// MARK: Ses gen view extension
extension SessionGeneratorView {
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
    @ObservedObject var sessionModel: SessionGeneratorModel
    @State private var showingSkillSelector = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Skills for Today")
                    .font(.custom("Poppins-Bold", size: 20))
                
                
                Button(action: { showingSkillSelector = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.yellow)
                }
                
                Spacer()
                
            }
            
            HStack {
                // Horizontal scrolling selected skills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(sessionModel.selectedSkills).sorted(), id: \.self) { skill in
                            if let category = SessionGeneratorView.skillCategories.first(where: { $0.subSkills.contains(skill) }) {
                                CompactSkillButton(
                                    title: skill,
                                    icon: category.icon,
                                    isSelected: true
                                ) { }
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
        .sheet(isPresented: $showingSkillSelector) {
            SkillSelectorSheet(selectedSkills: $sessionModel.selectedSkills)
        }
    }
}

// MARK: New Skill button
struct CompactSkillButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.custom("Poppins-Bold", size: 12))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.yellow)
                    .shadow(color: Color.yellow.opacity(0.3),
                           radius: 4, x: 0, y: 2)
            )
        }
    }
}

struct SkillSelectorSheet: View {
    @Binding var selectedSkills: Set<String>
    @Environment(\.dismiss) private var dismiss
    @State private var expandedCategory: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
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
                                HStack {
                                    Image(systemName: category.icon)
                                        .font(.system(size: 20))
                                    Text(category.name)
                                        .font(.custom("Poppins-Bold", size: 18))
                                    Spacer()
                                    Image(systemName: expandedCategory == category.name ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 14))
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .foregroundColor(.black)
                            
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
                                                    .font(.custom("Poppins-Bold", size: 16))
                                                Spacer()
                                                if selectedSkills.contains(subSkill) {
                                                    Image(systemName: "checkmark.circle.fill")
                                                        .foregroundColor(.yellow)
                                                }
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 8)
                                        }
                                        .foregroundColor(.black)
                                    }
                                }
                                .padding(.vertical)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Select Skills")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
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
                        .font(.custom("Poppins-Bold", size: 12))
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
    return NavigationView {
        SessionGeneratorView(model: mockOnboardingModel, appModel: mockAppModel)
    }
}
