//
//  DailySummaryCard.swift
//  ThreadSpace
//
//  Created by Christopher Castillo on 7/26/25.
//

import SwiftUI

struct DailySummaryCard: View {
    let mood: String
    let water: Double
    let sleep: Double

    var body: some View {
        VStack(alignment: .leading, spacing: ThreadSpaceTheme.Layout.padding) {
            Text("🌤️ Daily Summary")
                .font(ThreadSpaceTheme.Fonts.title)
                .foregroundColor(ThreadSpaceTheme.Colors.text)

            HStack(spacing: ThreadSpaceTheme.Layout.padding) {
                Label("Mood: \(mood)", systemImage: "face.smiling")
                    .font(ThreadSpaceTheme.Fonts.body)
                    .foregroundColor(ThreadSpaceTheme.Colors.text)

                Spacer()

                Label("💧 \(String(format: "%.1f", water)) L", systemImage: "drop")
                    .font(ThreadSpaceTheme.Fonts.body)
                    .foregroundColor(ThreadSpaceTheme.Colors.text)

                Spacer()

                Label("🛌 \(String(format: "%.1f", sleep)) hrs", systemImage: "bed.double.fill")
                    .font(ThreadSpaceTheme.Fonts.body)
                    .foregroundColor(ThreadSpaceTheme.Colors.text)
            }
        }
        .padding()
        .background(ThreadSpaceTheme.Colors.secondary.opacity(0.1))
        .cornerRadius(ThreadSpaceTheme.Layout.cornerRadius)
        .padding(.horizontal)
    }
}
