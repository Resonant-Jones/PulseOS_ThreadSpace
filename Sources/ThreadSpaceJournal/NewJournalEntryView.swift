import SwiftUI
import SwiftData

struct NewJournalEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var content = ""
    @State private var moodScore: Double = 0.5
    @State private var tags = ""

    var body: some View {
        Form {
            Section(header: Text("Reflection")) {
                TextEditor(text: $content)
                    .frame(height: 120)
            }

            Section(header: Text("Mood")) {
                Slider(value: $moodScore, in: 0...1)
                Text("Mood Score: \(moodScore, specifier: "%.2f")")
            }

            Section(header: Text("Tags")) {
                TextField("e.g. joy, fatigue", text: $tags)
            }

            Button("Save Entry") {
                let tagList = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
                let entry = JournalEntry(content: content, moodScore: moodScore, tags: tagList)
                modelContext.insert(entry)
                content = ""
                moodScore = 0.5
                tags = ""
            }
        }
        .navigationTitle("New Journal")
    }
}