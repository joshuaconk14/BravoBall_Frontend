import SwiftUI
import RiveRuntime

struct OnboardingView: View {
    @StateObject private var model = OnboardingModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            // Main content (Bravo and buttons)
            if !model.showWelcome && !model.showLoginPage {
                welcomeContent
            }
            
            // Login view with transition
            if model.showLoginPage {
                LoginView(model: model)
                    .transition(.move(edge: .bottom))
            }
            
            // Welcome/Questionnaire view with transition
            if model.showWelcome {
                questionnaireContent
                    .transition(.move(edge: .trailing))
            }
            
            // Intro animation overlay
            if model.showIntroAnimation {
                RiveViewModel(fileName: "tekk_intro").view()
                    .scaleEffect(model.animationScale)
                    .edgesIgnoringSafeArea(.all)
                    .allowsHitTesting(false)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) {
                            withAnimation(.spring()) {
                                model.showIntroAnimation = false
                            }
                        }
                    }
            }
        }
        .animation(.spring(), value: model.showWelcome)
        .animation(.spring(), value: model.showLoginPage)
    }
    
    var welcomeContent: some View {
        VStack {
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 300, height: 300)
                .padding(.top, 30)
                .padding(.bottom, 10)
            
            Text("BravoBall")
                .foregroundColor(model.globalSettings.primaryYellowColor)
                .padding(.bottom, 5)
                .font(.custom("PottaOne-Regular", size: 45))
            
            Text("Start Small. Dream Big")
                .foregroundColor(model.globalSettings.primaryDarkColor)
                .padding(.bottom, 100)
                .font(.custom("Poppins-Bold", size: 16))
            
            // Create Account Button
            Button(action: {
                withAnimation(.spring()) {
                    model.showWelcome.toggle()
                }
            }) {
                Text("Create an account")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(model.globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            .padding(.top, 80)
            
            // Login Button
            Button(action: {
                withAnimation(.spring()) {
                    model.showLoginPage = true
                }
            }) {
                Text("Login")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(.gray.opacity(0.2))
                    .foregroundColor(model.globalSettings.primaryDarkColor)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(.white)
    }
    
    var questionnaireContent: some View {
        VStack(spacing: 16) {
            // Progress Bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.gray.opacity(0.3))
                        .frame(height: 8)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .foregroundColor(model.globalSettings.primaryYellowColor)
                        .frame(width: geometry.size.width * (CGFloat(model.currentStep) / 10.0), height: 8)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
            .padding(.horizontal)
            
            // Mascot
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 100, height: 100)
            
            // Step Content
            ScrollView {
                switch model.currentStep {
                case 0:
                    OnboardingStepView(
                        model: model,
                        title: "What's your age range?",
                        options: model.ageRanges,
                        selection: $model.onboardingData.ageRange
                    )
                case 1:
                    OnboardingStepView(
                        model: model,
                        title: "What's your playing level?",
                        options: model.levels,
                        selection: $model.onboardingData.level
                    )
                case 2:
                    OnboardingStepView(
                        model: model,
                        title: "What position do you play?",
                        options: model.positions,
                        selection: $model.onboardingData.position
                    )
                case 3:
                    OnboardingMultiSelectView(
                        title: "Which players do you feel represent your playstyle?",
                        options: model.players,
                        selections: $model.onboardingData.playstyleRepresentatives
                    )
                case 4:
                    VStack(spacing: 20) {
                        OnboardingMultiSelectView(
                            title: "What are your biggest strengths?",
                            options: model.skills,
                            selections: $model.onboardingData.strengths
                        )
                        OnboardingMultiSelectView(
                            title: "What would you like to work on?",
                            options: model.skills,
                            selections: $model.onboardingData.weaknesses
                        )
                    }
                case 5:
                    OnboardingBooleanView(
                        title: "Are you currently playing for a team?",
                        selection: $model.onboardingData.hasTeam
                    )
                case 6:
                    OnboardingStepView(
                        model: model,
                        title: "What is your primary goal?",
                        options: model.goals,
                        selection: $model.onboardingData.primaryGoal
                    )
                case 7:
                    OnboardingStepView(
                        model: model,
                        title: "When are you looking to achieve this by?",
                        options: model.timelines,
                        selection: $model.onboardingData.timeline
                    )
                case 8:
                    OnboardingMultiSelectView(
                        title: "What days would you like to train?",
                        options: model.weekdays,
                        selections: $model.onboardingData.trainingDays
                    )
                case 9:
                    OnboardingMultiSelectView(
                        title: "What equipment do you have access to?",
                        options: model.equipment,
                        selections: $model.onboardingData.availableEquipment
                    )
                default:
                    CompletionView {
                        dismiss()
                    }
                }
            }
            .padding()
            
            // Navigation Buttons
            if model.currentStep < 10 {
                HStack {
                    Button(action: {
                        withAnimation {
                            model.movePrevious()
                        }
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(model.currentStep == 0 ? "Welcome" : "Back")
                        }
                        .foregroundColor(model.globalSettings.primaryDarkColor)
                    }
                    
                    Spacer()
                    
                    Button(model.currentStep == 9 ? "Finish" : "Next") {
                        withAnimation {
                            model.moveNext()
                        }
                    }
                    .disabled(!model.canMoveNext())
                }
                .padding()
            }
        }
    }
}

// Login View
struct LoginView: View {
    @ObservedObject var model: OnboardingModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome Back!")
                .font(.custom("PottaOne-Regular", size: 32))
                .foregroundColor(model.globalSettings.primaryDarkColor)
            
            RiveViewModel(fileName: "test_panting").view()
                .frame(width: 200, height: 200)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            Button(action: {
                // Handle login
            }) {
                Text("Login")
                    .frame(width: 325, height: 15)
                    .padding()
                    .background(model.globalSettings.primaryYellowColor)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .font(.custom("Poppins-Bold", size: 16))
            }
            
            Button("Cancel") {
                withAnimation(.spring()) {
                    model.showLoginPage = false
                }
            }
            .foregroundColor(model.globalSettings.primaryDarkColor)
        }
        .padding()
        .background(Color.white)
    }
}

// Helper Views
struct OnboardingStepView: View {
    @ObservedObject var model: OnboardingModel
    let title: String
    let options: [String]
    @Binding var selection: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
            
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selection = option
                }) {
                    HStack {
                        Text(option)
                        Spacer()
                        if selection == option {
                            Image(systemName: "checkmark")
                                .foregroundColor(model.globalSettings.primaryYellowColor)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selection == option ? model.globalSettings.primaryYellowColor : Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct OnboardingMultiSelectView: View {
    let title: String
    let options: [String]
    @Binding var selections: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
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
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selections.contains(option) ? Color.yellow : Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct OnboardingBooleanView: View {
    let title: String
    @Binding var selection: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
            
            HStack {
                Button(action: {
                    selection = true
                }) {
                    HStack {
                        Text("Yes")
                        if selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selection ? Color.yellow : Color.gray, lineWidth: 1)
                    )
                }
                
                Button(action: {
                    selection = false
                }) {
                    HStack {
                        Text("No")
                        if !selection {
                            Image(systemName: "checkmark")
                                .foregroundColor(.yellow)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(!selection ? Color.yellow : Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
}

struct CompletionView: View {
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image("BravoBallDog") // Replace with your actual mascot image
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("Creating your personalized training plan...")
                .font(.headline)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            
            Button("Get Started") {
                onComplete()
            }
            .padding()
            .background(Color.yellow)
            .foregroundColor(.black)
            .cornerRadius(10)
        }
        .padding()
    }
} 