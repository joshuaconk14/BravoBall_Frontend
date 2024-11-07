////
////  OnboardingView.swift
////  BravoBall
////
////  Created by Joshua Conklin on 9/30/24.//
//
//import SwiftUI
//import RiveRuntime
//
//struct OnboardingView: View {
//    @StateObject private var globalSettings = GlobalSettings()
//    @EnvironmentObject var stateManager: OnboardingStateManager
//    @EnvironmentObject var onboardingCoordinator: OnboardingCoordinator
//    @EnvironmentObject var bravoCoordinator: BravoCoordinator
//    
//    var body: some View {
//        ZStack {
//            Color.white.ignoresSafeArea()
//            
//            // Main content
//            VStack {
//                BravoView()
//                    .frame(width: 300, height: 300)
//                    .padding(.top, 30)
//                    .padding(.bottom, 10)
//                
//                Text("BravoBall")
//                    .foregroundColor(globalSettings.primaryYellowColor)
//                    .padding(.bottom, 5)
//                    .font(.custom("PottaOne-Regular", size: 45))
//                
//                Text("Start Small. Dream Big")
//                    .foregroundColor(Color(hex:"1E272E"))
//                    .padding(.bottom, 100)
//                    .font(.custom("Poppins-Bold", size: 16))
//                
//                // Get Started Button
//                Button(action: {
//                    onboardingCoordinator.moveToNext()
//                }) {
//                    Text("Get Started")
//                        .frame(width: 325, height: 15)
//                        .padding()
//                        .background(globalSettings.primaryYellowColor)
//                        .foregroundColor(.white)
//                        .cornerRadius(20)
//                        .font(.custom("Poppins-Bold", size: 16))
//                }
//                .padding(.bottom)
//            }
//        }
//        .onAppear {
//            bravoCoordinator.centerBravo()
//            bravoCoordinator.showMessage(onboardingCoordinator.currentStep.bravoMessage, duration: 0)
//        }
//    }
//}
//
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        let stateManager = OnboardingStateManager()
//        let onboardingCoordinator = OnboardingCoordinator()
//        let bravoCoordinator = BravoCoordinator()
//        
//        OnboardingView()
//            .environmentObject(OnboardingStateManager())
//            .environmentObject(OnboardingCoordinator())
//            .environmentObject(BravoCoordinator())
//    }
//}
