import Foundation

/// ThreadSpaceMemory acts as the central access point for all user memory artifacts:
/// Journals, Moods, Summaries, and cross-linked recall patterns.
public final class ThreadSpaceMemory {
    // MARK: - Memory Stores (In-Memory for Now — Replace with SwiftData/DB Layer)
    public private(set) var journalEntries: [JournalEntry] = []
    public private(set) var moodEntries: [MoodEntry] = []
    public private(set) var memorySummaries: [MemorySummary] = []

    // MARK: - Initialization

    public init() {
        // Optionally preload mock data or restore from persistence
    }

    // MARK: - Journal API

    public func addJournalEntry(_ entry: JournalEntry) {
        journalEntries.append(entry)
    }

    public func entries(on date: Date) -> [JournalEntry] {
        journalEntries.filter { Calendar.current.isDate($0.timestamp, inSameDayAs: date) }
    }

    public func allJournalEntries() -> [JournalEntry] {
        journalEntries.sorted(by: { $0.timestamp > $1.timestamp })
    }

    // MARK: - Mood API

    public func addMoodEntry(_ entry: MoodEntry) {
        moodEntries.append(entry)
    }

    public func recentMoodSummary(count: Int = 5) -> [MoodEntry] {
        moodEntries.sorted(by: { $0.timestamp > $1.timestamp }).prefix(count).map { $0 }
    }

    // MARK: - Summary API

    public func addSummary(_ summary: MemorySummary) {
        memorySummaries.append(summary)
    }

    public func summaries(forTag tag: String) -> [MemorySummary] {
        memorySummaries.filter { $0.tags?.contains(tag) == true }
    }

    public func summaries(forPeriod period: String) -> [MemorySummary] {
        memorySummaries.filter { $0.period == period }
    }

    // MARK: - Reflection API

    public func summarizeCurrentSeason() -> MemorySummary? {
        // Use current date to derive a season or month name
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"  // e.g., "July 2025"
        let currentPeriod = formatter.string(from: now)

        let relevantJournals = journalEntries.filter {
            Calendar.current.isDate($0.timestamp, equalTo: now, toGranularity: .month)
        }

        guard !relevantJournals.isEmpty else { return nil }

        let combinedText = relevantJournals.map(\.content).joined(separator: "\n\n")

        return MemorySummary(
            period: currentPeriod,
            summaryText: "User wrote \(relevantJournals.count) journal entries this month.",
            includedIDs: relevantJournals.map(\.id)
        )
    }

    // MARK: - Deep Archive Placeholder

    public func deepDiveSearch(query: String) -> String {
        // Placeholder for RAG, embeddings, or file-based vector recall
        return "This search would be powered by archived vector memory. [TODO]"
    }
}