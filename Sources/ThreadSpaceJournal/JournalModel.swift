import Foundation
import SwiftData

@Observable
final class JournalModel {
    @Published var entries: [JournalEntry] = []
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchEntries()
    }

    func fetchEntries() {
        let descriptor = FetchDescriptor<JournalEntry>(sortBy: [.init(\.timestamp, order: .reverse)])
        if let results = try? modelContext.fetch(descriptor) {
            entries = results
        }
    }

    func addEntry(content: String, moodScore: Double?, tags: [String]) {
        let entry = JournalEntry(content: content, moodScore: moodScore, tags: tags)
        modelContext.insert(entry)
        fetchEntries()
    }

    func archive(_ entry: JournalEntry) {
        entry.isArchived = true
        try? modelContext.save()
        fetchEntries()
    }
}