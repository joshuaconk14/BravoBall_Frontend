//
//  View_Chatbot.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//

import SwiftUI

struct Message_Struct: Identifiable {
    let id = UUID()
    let role: String
    var content: String
}

// Main chatbot view of the app
struct ChatbotView: View {
    @State private var isShowingHistory = false
    @State private var selectedSessionID = ""
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    var sendMessage: (String) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Main chat view
                VStack {
                    // Header
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingHistory.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.largeTitle)
                                .foregroundColor(.green)
                        }
                        Text("TekkAI")
                            .font(.largeTitle)
                            .bold()
                        
                        Button(action: {
                            startNewConversation()
                        }) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color.green)
                        }
                    }
                    .padding()
                    
                    // Chat messages
                    ScrollView {
                        ForEach(Array(chatMessages.enumerated()), id: \.element.id) { index, message in
                            MessageView(message: message)
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    .background(Color.gray.opacity(0.10))
                    
                    // Message input
                    HStack {
                        TextField("Let's get Tekky", text: $messageText)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .onSubmit {
                                sendMessage(messageText)
                                messageText = ""
                            }
                        
                        Button {
                            sendMessage(messageText)
                            messageText = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.green)
                        }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                    }
                    .padding()
                }
                .zIndex(0)
                
                // Overlay when history is showing (only over the chat area)
                if isShowingHistory {
                    Color.black.opacity(0.3)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isShowingHistory = false
                            }
                        }
                        .zIndex(1)
                }
                
                // Sliding chat history view
                if isShowingHistory {
                    ChatHistoryView(isShowingHistory: $isShowingHistory, selectedSessionID: $selectedSessionID)
                        .frame(width: geometry.size.width * 0.75)
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                }
            }
        }
    }
    // Function to start a new conversation
    private func startNewConversation() {
        chatMessages.removeAll { message in
            message.content != "Welcome to TekkAI"
        }
        // TODO: generate new session id
        // selectedSessionID = generateNewSessionID()
    }
}

struct MessageView: View {
    let message: Message_Struct
    
    var body: some View {
        Group {
            if message.content.contains("[USER]") {
                let newMessage = message.content.replacingOccurrences(of: "[USER]", with: "")
                HStack {
                    Spacer()
                    Text(newMessage)
                        .padding()
                        .foregroundColor(.white)
                        .background(.green.opacity(0.8))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
            } else {
                HStack {
                    Text(message.content)
                        .padding()
                        .background(.gray.opacity(0.15))
                        .cornerRadius(10)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                    Spacer()
                }
            }
        }
    }
}

struct ChatHistoryView: View {
    @Binding var isShowingHistory: Bool
    @Binding var selectedSessionID: String
    
    @State private var sessionIDs: [String] = [
        "TEKK",
        "mini",
        "4o",
        "CO Landing page"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Chat History")
                .font(.largeTitle)
                .padding(.top, 20)
                .padding(.leading, 10)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(sessionIDs, id: \.self) { sessionID in
                        Button(action: {
                            selectedSessionID = sessionID
                            withAnimation(.spring()) {
                                isShowingHistory = false
                            }
                        }) {
                            HStack {
                                Text(sessionID)
                                    .foregroundColor(.primary)
                                    .padding(.leading, 10)
                                
                                Spacer() // Pushes content to the left
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    ChatbotView(chatMessages: .constant([Message_Struct(role: "assistant", content: "Welcome to TekkAI")]), sendMessage: { _ in })
}
