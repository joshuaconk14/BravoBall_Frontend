//
//  ContentView.swift
//  Tekk
//
//  Created by Jordan on 7/9/24.
//

import SwiftUI
//import GoogleGenerativeAI

struct ContentView: View {
    @State private var messageText = "" // Current text input from user
    @State var chatMessages: [Message_Struct] = [Message_Struct(role: "system", content: "Welcome to TekkAI")] // Stores list of chat messages
    @State private var currentStreamingMessage = ""
    
    // main view
    var body: some View {
        TabView {
            // chatMessages binded, sendMessage passed as closure
            ChatbotView(chatMessages: $chatMessages, sendMessage: sendMessage)
                .tabItem() {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Camera")
                }
            SettingsView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Settings")
                }
        }
        .accentColor(.green)
    }
    
    class StreamingDelegate: NSObject, URLSessionDataDelegate {
        var onDataReceived: ((String) -> Void)?
        private var buffer = ""

        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            if let chunk = String(data: data, encoding: .utf8) {
                buffer += chunk
                while let newlineIndex = buffer.firstIndex(of: "\n") {
                    let line = String(buffer[..<newlineIndex])
                    buffer = String(buffer[buffer.index(after: newlineIndex)...])
                    if line.hasPrefix("data:") {
                        let cleanedChunk = line.replacingOccurrences(of: "data:", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
                        if !cleanedChunk.isEmpty {
                            onDataReceived?(cleanedChunk + " ") // Add a space after each chunk
                        }
                    }
                }
            }
        }

        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
            // Send any remaining data in the buffer
            if !buffer.isEmpty {
                let cleanedChunk = buffer.trimmingCharacters(in: .whitespacesAndNewlines)
                if !cleanedChunk.isEmpty {
                    onDataReceived?(cleanedChunk)
                }
            }
        }
    }


    func sendMessage(message: String) {
        withAnimation {
                chatMessages.append(Message_Struct(role: "user", content: "[USER]" + message))
                self.messageText = ""
                // Add an empty assistant message immediately
                chatMessages.append(Message_Struct(role: "assistant", content: ""))
            }

        let playerDetails = ["name": "Joe Lolley", "age": 18, "position": "LW"] as [String : Any]
        
        guard let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "prompt": message,
            "player_details": playerDetails
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])

        // Setup the delegate
        let delegate = StreamingDelegate()
        delegate.onDataReceived = { chunk in
                DispatchQueue.main.async {
                    withAnimation {
                        // Always update the last message, which should be the assistant's response
                        self.chatMessages[self.chatMessages.count - 1].content += chunk
                    }
                }
            }

        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        session.dataTask(with: request).resume()
    }

    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15 Pro Max")
    }
}




/*
 func sendMessage(message: String) {
     withAnimation {
         chatMessages.append(Message_Struct(role: "user", content: "[USER]" + message))
         self.messageText = ""
     }

     let playerDetails = ["name": "Joe Lolley", "age": 18, "position": "LW"] as [String : Any]
     
     guard let url = URL(string: "http://127.0.0.1:8000/generate_tutorial/") else { return }
     var request = URLRequest(url: url)
     
     request.httpMethod = "POST"
     request.setValue("application/json", forHTTPHeaderField: "Content-Type")
     
     let parameters: [String: Any] = [
         "prompt": message,
         "player_details": playerDetails
     ]
     
     request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
     
     let task = URLSession.shared.dataTask(with: request) { _, response, error in
         if let error = error {
             print("Error: \(error.localizedDescription)")
             return
         }
         
         guard let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) else {
             print("Invalid response")
             return
         }
         
         self.handleStreamingResponse(request: request)
     }
     
     task.resume()
 }
 
 
 func handleStreamingResponse(request: URLRequest) {
     URLSession.shared.dataTask(with: request) { data, response, error in
         guard let data = data, error == nil else {
             print("Error: \(error?.localizedDescription ?? "Unknown error")")
             return
         }
         
         var streamedMessage = ""
         var buffer = Data()
         
         let newlineData = "\n".data(using: .utf8)!
         let dataPrefix = "data:".data(using: .utf8)!
         
         data.forEach { byte in
             buffer.append(byte)
             
             if byte == newlineData.first {
                 if buffer.starts(with: dataPrefix) {
                     let messageData = buffer.dropFirst(dataPrefix.count)
                     if let message = String(data: messageData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                         streamedMessage += message
                         DispatchQueue.main.async {
                             self.currentStreamingMessage = streamedMessage
                             if let lastMessage = self.chatMessages.last, lastMessage.role == "assistant" {
                                 self.chatMessages[self.chatMessages.count - 1].content = streamedMessage
                             } else {
                                 self.chatMessages.append(Message_Struct(role: "assistant", content: streamedMessage))
                             }
                         }
                     }
                 }
                 buffer = Data()
             }
         }
     }.resume()
 }
 
 
 */
