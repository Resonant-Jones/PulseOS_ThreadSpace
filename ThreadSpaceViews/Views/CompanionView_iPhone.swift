//
//  CompanionView_iPhone.swift
//  ThreadSpace
//
//  Generated SwiftUI boilerplate for iPhone chat UI
//

import SwiftUI

struct CompanionView_iPhone: View {
    @State private var messages: [ChatMessage] = []
    @State private var newMessage: String = ""
    @State private var isTyping = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Chat messages list
                ScrollViewReader { scrollView in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(messages) { message in
                                ChatBubble(message: message)
                            }
                            
                            if isTyping {
                                TypingIndicator()
                            }
                        }
                        .padding()
                    }
                }
                
                // Input bar
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $newMessage)
                        .textFieldStyle(.roundedBorder)
                        .frame(minHeight: 36)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(newMessage.isEmpty ? Color.gray : Color.blue)
                            .clipShape(Circle())
                    }
                    .disabled(newMessage.isEmpty)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .navigationTitle("Pulse Companion")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func sendMessage() {
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            id: UUID(),
            text: newMessage,
            isUser: true,
            timestamp: Date()
        )
        
        messages.append(userMessage)
        newMessage = ""
        
        // Simulate AI response
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isTyping = false
            let aiMessage = ChatMessage(
                id: UUID(),
                text: "This is a placeholder AI response. Replace with actual PulseOS companion logic.",
                isUser: false,
                timestamp: Date()
            )
            messages.append(aiMessage)
        }
    }
}

// MARK: - Supporting Models & Views

struct ChatMessage: Identifiable, Hashable {
    let id: UUID
    let text: String
    let isUser: Bool
    let timestamp: Date
}

struct ChatBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isUser ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isUser { Spacer() }
        }
    }
}

struct TypingIndicator: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: animate
                    )
            }
        }
        .onAppear { animate = true }
        .padding(.leading, 8)
    }
}

#Preview {
    CompanionView_iPhone()
}
