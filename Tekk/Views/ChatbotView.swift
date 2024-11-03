//
//  ChatbotView.swift
//  Tekk-frontend
//
//  Created by Jordan on 7/6/24.
//  This file contains the ChatbotView, which is used to display the chatbot.

import SwiftUI



// Main chatbot view of the app
struct ChatbotView: View {
    @State private var isShowingHistory = false
    @State private var selectedSessionID = ""
    @State private var messageText = ""
    @Binding var chatMessages: [Message_Struct]
    @Binding var authToken: String
    @State private var viewModel = ViewModel()
    @Binding var conversations: [Conversation]
    @State private var activeTab: Tab = .messages


    enum Tab {
        case messages, camera, modifier
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Main chat view
                VStack(spacing: 1) {
                    // Header
                    HStack {
                        // Button(action: {
                        //     withAnimation(.spring()) {
                        //         isShowingHistory.toggle()
                        //     }
                        // }) {
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingHistory.toggle()
                                if isShowingHistory {
                                    fetchConversations()
                                }
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("BravoBall")
                            .foregroundColor(.white)
                            .font(.custom("PottaOne-Regular", size: 30))
                        
                        Spacer()
                        Button(action: startNewConversation) {
                            Image(systemName: "bubble.left.fill")
                                .font(.system(size: 26))
                                .foregroundColor(Color.white)
                        }
                    }
                    // header customization
                    .padding()
                    .frame(width: geometry.size.width)
                    .background(Color(hex: "947F63"))
                    
                    
                    

                    // Chat messages
                    ScrollView {
                        ForEach(chatMessages) { message in
                            MessageView(message: message)
                        }
                        .rotationEffect(.degrees(180))
                    }
                    .rotationEffect(.degrees(180))
                    .background(Color(hex:"1E272E"))
                    
                    // Message input
                    HStack {
                        TextField("Let's get Tekky", text: $messageText)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                                .stroke(Color.black.opacity(0.2), lineWidth: 6)
                            )
                            .accentColor(.black) // This sets the cursor color
                            .onSubmit {
                                sendMessage(message: messageText)
                                messageText = ""
                            }
                        
                        Button {
                            sendMessage(message: messageText)
                            messageText = ""
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                        }
                        .font(.system(size: 26))
                        .padding(.horizontal, 10)
                    }
                    .padding()
                    .background(Color(hex:"1E272E"))
                }
                .zIndex(0)
                
                // Overlay when history is showing (only over the chat area)
                if isShowingHistory {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
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
                    ChatHistoryView(isShowingHistory: $isShowingHistory,
                                    selectedSessionID: $selectedSessionID,
                                    conversations: $conversations,
                                    loadConversation: loadConversation,
                                    fetchConversations: fetchConversations,
                                    deleteConversation: deleteConversation)
                    .frame(width: geometry.size.width * 0.75)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
                }
            }
        }
    }

    // navigation bar buttons
    private func navigationButton(tab: Tab, icon: String) -> some View {
        Button(action: {
            activeTab = tab
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
        }
    }
    
    // API call to send user input to the chatbot and get a response
    func sendMessage(message: String) {
        withAnimation {
            chatMessages.append(Message_Struct(role: "user", content: "[USER]" + message))
            self.messageText = ""
        }
        
        let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/")!
        var request = URLRequest(url: url)
        
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        print("Token in ChatbotView: \(storedToken)")
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "prompt": message,
            "session_id": selectedSessionID
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response data: \(responseString)")
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(TutorialResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.chatMessages.append(Message_Struct(role: "assistant", content: decodedResponse.tutorial))
                        self.selectedSessionID = decodedResponse.session_id
                        
                        // Update the conversation title if it's a new conversation
                        if let index = self.conversations.firstIndex(where: { $0.id == decodedResponse.session_id }) {
                            self.conversations[index].title = message
                        } else {
                            let newConversation = Conversation(id: decodedResponse.session_id, title: message, createdAt: Date())
                            self.conversations.insert(newConversation, at: 0)
                        }
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                }
            } else {
                print("No data received")
            }
        }
        .resume()
    }

    // API call to load a conversation in some conversation session
    func loadConversation(_ id: String) {
        let url = URL(string: "http://127.0.0.1:8000/conversations/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error loading conversation: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when loading conversation")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ConversationResponse.self, from: data)
                DispatchQueue.main.async {
                self.chatMessages = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
                self.chatMessages += decodedResponse.messages.map { message in
                    Message_Struct(role: message.role, content: message.role == "user" ? "[USER]" + message.content : message.content)
                }
                self.selectedSessionID = id
            }
            } catch {
                print("Error parsing conversation response: \(error.localizedDescription)")
            }
        }
        .resume()
    }

    // API call to start a new conversation (creates new conversation session ID and empty chat history)
    func startNewConversation() {
        let url = URL(string: "http://127.0.0.1:8000/conversations/new")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")

        print("Starting new conversation with auth token: \(storedToken)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating new conversation: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received when creating new conversation")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let newSessionId = json["session_id"] as? String {
                    DispatchQueue.main.async {
                        self.selectedSessionID = newSessionId
                        self.chatMessages = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
                        let newConversation = Conversation(id: newSessionId, title: "New Conversation", createdAt: Date())
                        self.conversations.insert(newConversation, at: 0)
                        print("New conversation started with session ID: \(newSessionId)")
                    }
                }
            } catch {
                print("Error parsing new conversation response: \(error.localizedDescription)")
            }
        }
        .resume()
    }

    // API call to fetch previous conversations when user opens Chat History
    func fetchConversations() {
        let url = URL(string: "http://127.0.0.1:8000/get_previous_conversations/")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")
        
        print("Fetching conversations with token: \(storedToken)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching conversations: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received when fetching conversations")
                return
            }
            
            print("Raw data received: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
            
            do {
                // decode the date field in the response
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .custom { decoder in
                    let container = try decoder.singleValueContainer()
                    let dateString = try container.decode(String.self)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    if let date = formatter.date(from: dateString) {
                        return date
                    }
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
                }
                let response = try decoder.decode(PreviousConversationsResponse.self, from: data)
                print("Successfully decoded response. Number of conversations: \(response.conversations.count)")
                DispatchQueue.main.async {
                    self.conversations = response.conversations.sorted(by: { $0.createdAt > $1.createdAt })
                    print("Updated conversations: \(self.conversations)")
                }
            } catch {
                print("Error parsing conversations response: \(error)")
            }
        }.resume()
    }

    // API call to delete a conversation
    func deleteConversation(_ id: String) {
        let url = URL(string: "http://127.0.0.1:8000/conversations/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error deleting conversation: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    if let index = self.conversations.firstIndex(where: { $0.id == id }) {
                        self.conversations.remove(at: index)
                    }
                    if self.selectedSessionID == id {
                        self.chatMessages = [Message_Struct(role: "system", content: "Welcome to TekkAI")]
                        self.selectedSessionID = ""
                    }
                }
            } else {
                print("Failed to delete conversation")
            }
        }.resume()
    }
}

// The messages in the chatbot corresponding to if message is from user or AI
struct MessageView: View {
    let message: Message_Struct
    
    var body: some View {
        HStack {
            if message.role == "user" {
                Spacer()
                Text(message.content.replacingOccurrences(of: "[USER]", with: ""))
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(hex:"947F63").opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
            } else {
                Text(message.content)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 10)
                Spacer()
            }
        }
    }
}


// chat history views
struct ChatHistoryView: View {
    @Binding var isShowingHistory: Bool
    @Binding var selectedSessionID: String
    @Binding var conversations: [Conversation]
    var loadConversation: (String) -> Void
    var fetchConversations: () -> Void
    var deleteConversation: (String) -> Void
    @State private var showingDeleteConfirmation = false
    @State private var conversationToDelete: Conversation?


    var body: some View {
        GeometryReader { geometry in
            VStack (spacing:0) {
                //green header
                HStack {
                    Text("Chat History")
                        .font(.largeTitle)
                        .padding(.top, 20)
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            isShowingHistory = false
                        }
                    }) {
                        Image(systemName:"xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .frame(width: geometry.size.width)
                .background(Color(hex:"1E272E"))
                
                // chat history content
                if conversations.isEmpty {
                    Text("No conversations yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(conversations) { conversation in
                                HStack {
                                    Button(action: {
                                        loadConversation(conversation.id)
                                        withAnimation(.spring()) {
                                            isShowingHistory = false
                                        }
                                    }) {
                                        HStack {
                                            Text(conversation.title)
                                                .foregroundColor(.primary)
                                                .padding(.leading, 10)
                                            
                                            Spacer()
                                            
                                            Text(conversation.createdAt, style: .date)
                                                .foregroundColor(.secondary)
                                                .font(.caption)
                                        }
                                    }
                                    
                                    Button(action: {
                                        conversationToDelete = conversation
                                        showingDeleteConfirmation = true
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                    .padding(.trailing, 10)
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding(.horizontal)
                            }
                        }
                        .padding(.top, 30)
                    }
                }
                Spacer()
            }
            .frame(width: geometry.size.width)
            .background(Color(hex:"1E272E"))
        }
        .onAppear {
            fetchConversations()
            print("ChatHistoryView appeared with \(conversations.count) conversations")
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Conversation"),
                message: Text("Are you sure you want to delete this conversation?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let conversation = conversationToDelete {
                        deleteConversation(conversation.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}
    // private func deleteConversation(_ conversation: Conversation) {
    //     // API call to delete conversation
    //     let url = URL(string: "http://127.0.0.1:8000/conversations/\(conversation.id)")!
    //     var request = URLRequest(url: url)
    //     request.httpMethod = "DELETE"
    //     let storedToken = UserDefaults.standard.string(forKey: "authToken") ?? ""
    //     request.setValue("Bearer \(storedToken)", forHTTPHeaderField: "Authorization")

    //     URLSession.shared.dataTask(with: request) { data, response, error in
    //         if let error = error {
    //             print("Error deleting conversation: \(error.localizedDescription)")
    //             return
    //         }
            
    //         if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
    //             DispatchQueue.main.async {
    //                 if let index = self.conversations.firstIndex(where: { $0.id == conversation.id }) {
    //                     self.conversations.remove(at: index)
    //                 }
    //             }
    //         } else {
    //             print("Failed to delete conversation")
    //         }
    //     }.resume()
    // }


// Preview
struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView(
            chatMessages: .constant([
                Message_Struct(role: "system", content: "Welcome to TekkAI"),
                Message_Struct(role: "user", content: "[USER]How can I improve my dribbling?"),
                Message_Struct(role: "assistant", content: "To improve your dribbling, try these tips:\n\n1. Practice close control\n2. Use both feet\n3. Keep your head up\n4. Start slow and increase speed")
            ]),
            authToken: .constant("sample_token"),
            conversations: .constant([
                Conversation(id: "1", title: "Dribbling Techniques", createdAt: Date()),
                Conversation(id: "2", title: "Shooting Practice", createdAt: Date().addingTimeInterval(-86400))
            ])
        )
        .previewLayout(.device)
        .previewDevice("iPhone 15 Pro")
    }
}
