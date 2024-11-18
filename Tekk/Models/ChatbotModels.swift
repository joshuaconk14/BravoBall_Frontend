//
//  Models.swift
//  Tekk
//
//  Created by Jordan on 9/4/24.
//  This file contains the data models for the chatbot and chat history.

import Foundation

// expected response structure from backend after GET request to conversations/<id> endpoint
struct ConversationResponse: Codable {
    let id: String
    let messages: [APIMessage]
}

// expected response structure from backend after GET request to get_previous_conversations endpoint
struct PreviousConversationsResponse: Codable {
    let conversations: [Conversation]
}

// structure for messages in a conversation
struct APIMessage: Codable {
    let role: String
    let content: String
}

// structure for chat messages
struct Message_Struct: Identifiable {
    let id = UUID()
    let role: String
    var content: String
}

// expected response structure from backend after POST request to generate_tutorial endpoint
struct TutorialResponse: Codable {
    let tutorial: String
    let session_id: String
    // let created_at: String
}

// structure for a conversation, displayed in ChatHistoryView to show previous conversations
struct Conversation: Identifiable, Codable {
    let id: String
    var title: String
    let createdAt: Date
}
