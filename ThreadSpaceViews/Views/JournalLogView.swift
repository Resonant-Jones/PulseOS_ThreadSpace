//
//  JournalLogView.swift
//  ThreadSpace
//
//  Created by Christopher Castillo on 7/26/25.
//


import SwiftUI

struct JournalLogView: View {
    @State private var entries: [String] = [
        "Felt energized after a morning walk.",
        "Struggled with focus during work today.",
        "Had a great talk with an old friend.",
        "Practiced breathwork before bed."
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(entries, id: \.self) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(entry)
                            .font(ThreadSpaceTheme.Fonts.body)
                            .foregroundColor(ThreadSpaceTheme.Colors.text)

                        Text("• \(Date(), formatter: itemFormatter)")
                            .font(ThreadSpaceTheme.Fonts.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Journal Logs")
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
