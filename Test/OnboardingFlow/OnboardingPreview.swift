import SwiftUI

struct OnboardingPreview: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

// Sample View to present the onboarding
struct ContentView: View {
    @StateObject private var model = OnboardingModel()
    
    var body: some View {
        VStack {
            if model.isLoggedIn {
                Text("Main App Content")
                    .font(.title)
                
                Button("Show Onboarding Again") {
                    model.isLoggedIn = false
                }
            } else {
                OnboardingView()
            }
        }
    }
} 