SimplifiedCompanionView.swift
//  ThreadSpace
//
//  Generated SwiftUI boilerplate for minimal iPad portrait mode UI
//

import SwiftUI

struct SimplifiedCompanionView: View {
    @State private var currentPrompt: String = ""
    @State private var responses: [String] = []
    @State private var isProcessing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Single column content area
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Header
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pulse Companion")
                                .font(.title2.bold())
                            Text("Simplified iPad Portrait Mode")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        // Input section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("What would you like to explore?")
                                .font(.headline)
                            
                            TextField("Enter your prompt...", text: $currentPrompt, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3...6)
                            
                            Button(action: processPrompt) {
                                HStack {
                                    if isProcessing {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                    }
                                    Text("Process")
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(currentPrompt.isEmpty || isProcessing)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Responses section
                        if !responses.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Responses")
                                    .font(.headline)
                                
                                ForEach(responses.indices, id: \.self) { index in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Response \(index + 1)")
                                            .font(.subheadline.bold())
                                            .foregroundColor(.accentColor)
                                        
                                        Text(responses[index])
                                            .font(.body)
                                            .padding()
                                            .background(Color(.systemBackground))
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Placeholder content