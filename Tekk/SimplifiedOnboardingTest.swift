//
//  SimplifiedOnboardingTest.swift
//  BravoBall
//
//  Created by Jordan on 11/10/24.
//

import Foundation
import SwiftUI
import RiveRuntime

// MARK: - Data Model
struct TestOnboardingData {
    var firstName: String = ""
    var lastName: String = ""
    var ageRange: String = ""
    var level: String = ""
    var position: String = ""
    var playstyle: [String] = []
    var strengths: [String] = []
    var weaknesses: [String] = []
    var hasTeam: Bool = false
    var goal: String = ""
    var timeline: String = ""
    var trainingLevel: String = ""
    var trainingDays: [String] = []
}

// MARK: - Main View
class SimplifiedOnboardingViewModel: ObservableObject {
    @Published var currentStep = 0
    @Published var data = TestOnboardingData()
    @Published var isComplete = false
    
    // Options for selections
    let ageRanges = ["Under 12", "12-15", "16-18", "18+"]
    let levels = ["Beginner", "Intermediate", "Advanced", "Professional"]
    let positions = ["Forward", "Midfielder", "Defender", "Goalkeeper"]
    let playstyles = ["Messi", "Ronaldo", "Haaland", "Mbappe"]
    let strengths = ["Speed", "Shooting", "Passing", "Dribbling"]
    let weaknesses = ["Stamina", "Weak Foot", "Headers", "Tackling"]
    let goals = ["Pro Player", "College Player", "Improve Skills", "Have Fun"]
    let timelines = ["3 months", "6 months", "1 year", "2+ years"]
    let trainingLevels = ["Light", "Moderate", "Intense", "Professional"]
    let availableDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    func nextStep() {
        if validateCurrentStep() {
            if currentStep < totalSteps - 1 {
                currentStep += 1
            } else {
                completeOnboarding()
            }
        }
    }
    
    func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }
    
    var totalSteps: Int { 13 }
    
    private func validateCurrentStep() -> Bool {
        switch currentStep {
        case 0: return true // Welcome screen
        case 1: return !data.firstName.isEmpty && !data.lastName.isEmpty
        case 2: return !data.ageRange.isEmpty
        case 3: return !data.level.isEmpty
        case 4: return !data.position.isEmpty
        case 5: return !data.playstyle.isEmpty
        case 6: return !data.strengths.isEmpty
        case 7: return !data.weaknesses.isEmpty
        case 8: return true // hasTeam is always valid (bool)
        case 9: return !data.goal.isEmpty
        case 10: return !data.timeline.isEmpty
        case 11: return !data.trainingLevel.isEmpty
        case 12: return !data.trainingDays.isEmpty
        default: return false
        }
    }
    
    private func completeOnboarding() {
        print("✅ Onboarding Complete!")
        print("Final Data:", data)
        isComplete = true
    }
}

// MARK: - View
struct SimplifiedOnboardingView: View {
    @StateObject private var viewModel = SimplifiedOnboardingViewModel()
    @StateObject private var globalSettings = GlobalSettings()
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Progress indicator
                if viewModel.currentStep > 0 {
                    ProgressView(value: Double(viewModel.currentStep), total: Double(viewModel.totalSteps - 1))
                        .padding()
                }
                
                // Bravo Animation
                RiveViewModel(fileName: "test_panting").view()
                    .frame(width: viewModel.currentStep == 0 ? 300 : 250,
                           height: viewModel.currentStep == 0 ? 300 : 250)
                    .padding(.top, viewModel.currentStep == 0 ? 30 : -50)
                    .offset(x: viewModel.currentStep == 0 ? 0 : -75)
                
                if viewModel.currentStep == 0 {
                    // Welcome screen content
                    Text("BravoBall")
                        .foregroundColor(globalSettings.primaryYellowColor)
                        .font(.custom("PottaOne-Regular", size: 45))
                        .padding(.bottom, 5)
                    
                    Text("Start Small. Dream Big")
                        .foregroundColor(globalSettings.primaryDarkColor)
                        .font(.custom("Poppins-Bold", size: 16))
                        .padding(.bottom, 100)
                }
                
                // Current step content
                ScrollView {
                    VStack(spacing: 20) {
                        stepContent
                            .padding()
                    }
                }
                .frame(maxHeight: viewModel.currentStep == 0 ? 0 : .infinity)
                
                // Navigation buttons
                if viewModel.currentStep == 0 {
                    Button(action: { viewModel.nextStep() }) {
                        Text("Create an account")
                            .frame(width: 325, height: 15)
                            .padding()
                            .background(globalSettings.primaryYellowColor)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                    .padding(.top, 80)
                    
                    Button(action: {}) {
                        Text("Login")
                            .frame(width: 325, height: 15)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(globalSettings.primaryDarkColor)
                            .cornerRadius(20)
                            .font(.custom("Poppins-Bold", size: 16))
                    }
                } else {
                    // Next/Back navigation
                    HStack {
                        if viewModel.currentStep > 0 {
                            Button(action: { viewModel.previousStep() }) {
                                Image(systemName: "arrow.left")
                                    .font(.title2)
                                    .foregroundColor(globalSettings.primaryDarkColor)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: { viewModel.nextStep() }) {
                            Text("Next")
                                .frame(width: 325, height: 15)
                                .padding()
                                .background(globalSettings.primaryYellowColor)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                                .font(.custom("Poppins-Bold", size: 16))
                        }
                    }
                    .padding()
                }
            }
        }
        .alert("Onboarding Complete", isPresented: $viewModel.isComplete) {
            Button("OK", role: .cancel) { }
        }
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch viewModel.currentStep {
        case 0:
            EmptyView()
            
        case 1:
            VStack(spacing: 20) {
                TextField("First Name", text: $viewModel.data.firstName)
                    .textFieldStyle(CustomTextFieldStyle())
                TextField("Last Name", text: $viewModel.data.lastName)
                    .textFieldStyle(CustomTextFieldStyle())
            }
            
        case 2:
            SelectionView(
                title: "What's your age range?",
                options: viewModel.ageRanges,
                selection: $viewModel.data.ageRange
            )
            
        case 3:
            SelectionView(
                title: "What's your skill level?",
                options: viewModel.levels,
                selection: $viewModel.data.level
            )
            
        case 4:
            SelectionView(
                title: "What's your position?",
                options: viewModel.positions,
                selection: $viewModel.data.position
            )
            
        case 5:
            MultiSelectionView(
                title: "Which players represent your playstyle?",
                options: viewModel.playstyles,
                selections: $viewModel.data.playstyle
            )
            
        case 6:
            MultiSelectionView(
                title: "What are your biggest strengths?",
                options: viewModel.strengths,
                selections: $viewModel.data.strengths
            )
            
        case 7:
            MultiSelectionView(
                title: "What would you like to work on?",
                options: viewModel.weaknesses,
                selections: $viewModel.data.weaknesses
            )
            
        case 8:
            SelectionView(
                title: "Are you currently playing for a team?",
                options: ["Yes", "No"],
                selection: Binding(
                    get: { viewModel.data.hasTeam ? "Yes" : "No" },
                    set: { viewModel.data.hasTeam = ($0 == "Yes") }
                )
            )
            
        case 9:
            SelectionView(
                title: "What is your primary goal?",
                options: viewModel.goals,
                selection: $viewModel.data.goal
            )
            
        case 10:
            SelectionView(
                title: "When are you looking to achieve this by?",
                options: viewModel.timelines,
                selection: $viewModel.data.timeline
            )
            
        case 11:
            SelectionView(
                title: "What's your training intensity level?",
                options: viewModel.trainingLevels,
                selection: $viewModel.data.trainingLevel
            )
            
        case 12:
            MultiSelectionView(
                title: "Which days can you train?",
                options: viewModel.availableDays,
                selections: $viewModel.data.trainingDays
            )
            
        default:
            Text("Completed!")
        }
    }
}

// MARK: - Helper Views
struct SelectionView: View {
    let title: String
    let options: [String]
    @Binding var selection: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: { selection = option }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selection == option {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(selection == option ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct MultiSelectionView: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    if selections.contains(option) {
                        selections.removeAll { $0 == option }
                    } else {
                        selections.append(option)
                    }
                }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selections.contains(option) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .padding()
                    .background(selections.contains(option) ? Color.blue.opacity(0.1) : Color.clear)
                    .cornerRadius(8)
                }
            }
        }
    }
}

// Custom TextField Style to match your UI
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
            .font(.custom("Poppins-Regular", size: 16))
    }
}
