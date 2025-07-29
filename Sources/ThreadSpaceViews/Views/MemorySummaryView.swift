import SwiftUI

/// Simple view to display and add memory summaries
struct MemorySummaryView: View {
    @ObservedObject private var memoryManager = MemoryManager.shared

    @State private var period = ""
    @State private var summaryText = ""
    @State private var tagsText = ""
    @State private var emotionalTone = ""

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("New Summary")) {
                        TextField("Period (e.g. Spring 2025)", text: $period)
                        TextField("Summary", text: $summaryText)
                        TextField("Tags (comma separated)", text: $tagsText)
                        TextField("Emotional Tone", text: $emotionalTone)

                        Button("Save Summary") {
                            let tags = tagsText
                                .split(separator: ",")
                                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                            let newSummary = MemorySummary(
                                period: period,
                                summaryText: summaryText,
                                includedIDs: [],
                                tags: tags.isEmpty ? nil : tags,
                                emotionalTone: emotionalTone
                            )

                            memoryManager.addSummary(newSummary)

                            period = ""
                            summaryText = ""
                            tagsText = ""
                            emotionalTone = ""
                        }
                    }

                    Section(header: Text("All Summaries")) {
                        List(memoryManager.summaries) { summary in
                            VStack(alignment: .leading) {
                                Text(summary.period)
                                    .font(.headline)
                                Text(summary.summaryText)
                                    .font(.subheadline)
                                if let tags = summary.tags {
                                    Text("Tags: \(tags.joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Memory")
        }
    }
}