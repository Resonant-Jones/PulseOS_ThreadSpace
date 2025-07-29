import SwiftUI
import SwiftData

struct JournalEntryView: View {
    @Bindable var entry: JournalEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.content)
                .font(.body)
            if let score = entry.moodScore {
                Text("Mood Score: \(score, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                ForEach(entry.tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.caption2)
                        .foregroundStyle(.blue)
                }
            }
            if let voice = entry.voiceNoteURL {
                Text("🎤 Voice note attached").font(.caption)
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}