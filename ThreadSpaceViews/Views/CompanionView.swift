//
//  CompanionView.swift
//  ThreadSpace
//
//  Created by Christopher Castillo on 7/26/25.
//

import SwiftUI
import ThreadSpaceCore

struct CompanionView: View {
    @State private var prompt: String = ""
    @State private var result: Intention?
    @State private var suggestions: [Suggestion] = []
    @State private var isProcessing = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("What are you trying to do?", text: $prompt)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button(action: runTracking) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                        } else {
                            Image(systemName: "sparkles")
                        }
                        Text("Track Intention")
                    }
                }

                if let result = result {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🎯 Intention Summary:")
                            .font(.headline)
                        Text(result.summary)
                        Text("Urgency: \(String(format: "%.2f", result.urgencyScore))")
                        Text("Activation: \(String(format: "%.2f", result.activationScore))")
                    }
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(10)
                }

                if !suggestions.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("🧭 Suggestions:")
                            .font(.headline)

                        ForEach(suggestions, id: \.originalIntent.id) { suggestion in
                            VStack(alignment: .leading) {
                                Text("→ Failure Rate: \(String(format: "%.2f", suggestion.failureRate))")
                                ForEach(suggestion.alternatives, id: \.identityNodeID) { alt in
                                    Text("• \(alt.summary) [\(String(format: "%.2f", alt.alignmentScore))]")
                                }
                            }
                            .padding(.bottom, 8)
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .navigationTitle("Companion")
            .padding(.top)
        }
    }

    func runTracking() {
        isProcessing = true
        IdentityBridge.initialize()
        DispatchQueue.global(qos: .userInitiated).async {
            let intent = IdentityBridge.trackIntention(from: prompt)
            let shifts = IdentityBridge.suggestIntentionShift()
            DispatchQueue.main.async {
                self.result = intent
                self.suggestions = shifts
                self.isProcessing = false
            }
        }
    }
}
