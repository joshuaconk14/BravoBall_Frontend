//
//  BravoCoordinator.swift
//  BravoBall
//
//  Created by Jordan on 11/4/24.
//

import Foundation
import SwiftUI
import RiveRuntime

class BravoCoordinator: ObservableObject {
   @Published var position: CGSize = .zero
   @Published var isVisible: Bool = true
   @Published var message: String = ""
   @Published var scale: CGFloat = 1.0
   @Published var offset: CGSize = .zero
   
   func moveBravo(to position: CGSize, withAnimation shouldAnimate: Bool = true) {
       let action = {
           self.position = position
       }
       
       if shouldAnimate {
           withAnimation(.easeInOut(duration: 0.5)) {
               action()
           }
       } else {
           action()
       }
   }
   
   func showMessage(_ text: String, duration: Double = 2.0) {
       withAnimation {
           message = text
       }
       
       if duration > 0 {
           DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
               withAnimation {
                   self.message = ""
               }
           }
       }
   }
   
   func moveToSide() {
       withAnimation(.spring()) {
           position = CGSize(width: -75, height: -250)
       }
   }
   
   func centerBravo() {
       withAnimation(.spring()) {
           position = .zero
       }
   }
   
   func transitionToNextView() {
       withAnimation(.spring()) {
           scale = 0.8
           offset = CGSize(width: -100, height: -150)
       }
   }
}

struct BravoView: View {
   @EnvironmentObject var bravoCoordinator: BravoCoordinator
   var showMessage: Bool = false
   
   var body: some View {
       VStack {
           RiveViewModel(fileName: "test_panting").view()
               .frame(width: 250, height: 250)
               .offset(x: bravoCoordinator.position.width + bravoCoordinator.offset.width,
                      y: bravoCoordinator.position.height + bravoCoordinator.offset.height)
               .scaleEffect(bravoCoordinator.scale)
           
           if showMessage && !bravoCoordinator.message.isEmpty {
               Text(bravoCoordinator.message)
                   .foregroundColor(.black)
                   .padding(.horizontal, 80)
                   .multilineTextAlignment(.center)
                   .font(.custom("Poppins-Bold", size: 16))
                   .transition(.opacity)
           }
       }
   }
}
