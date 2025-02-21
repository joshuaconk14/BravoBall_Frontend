//
//  ToastMessageView.swift
//  BravoBall
//
//  Created by Joshua Conklin on 2/20/25.
//
import SwiftUI

// MARK: testing


// Toast view component
struct ToastView: View {
    let message: MainAppModel.ToastMessage
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: message.type.icon)
            Text(message.message)
                .font(.custom("Poppins-Medium", size: 14))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(message.type.color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(message.type.color.opacity(0.2), lineWidth: 1)
                )
        )
        .foregroundColor(message.type.color)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

// Overlay modifier for toast
struct ToastModifier: ViewModifier {
    @ObservedObject var appModel: MainAppModel
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let toast = appModel.toastMessage {
                VStack {
                    Spacer()
                    ToastView(message: toast)
                        .padding(.bottom, 32)
                }
                .transition(.opacity)
            }
        }
        .animation(.spring(dampingFraction: 0.7), value: appModel.toastMessage)
    }
}

// Extension for easy usage, displays toastmodifier with toastview
extension View {
    func toastOverlay(appModel: MainAppModel) -> some View {
        modifier(ToastModifier(appModel: appModel))
    }
}
