import Foundation

/// Represents a high-level summary of memories across a defined time period (e.g. a month or season).
/// Used for fast semantic recall, journaling overviews, and surfacing patterns in the user's life.
struct MemorySummary: Codable, Identifiable, Equatable, Hashable {
    /// Unique identifier for this summary
    let id: UUID

    /// Time period covered by this summary, e.g. "May 2025" or "Spring 2025"
    let period: String

    /// Natural language reflection of what happened during this period
    var summaryText: String

    /// IDs of the individual memory entries (e.g., journals, logs, events) included in this summary
    var includedIDs: [UUID]

    /// Timestamp indicating when the summary was last updated or reviewed
    var lastUpdated: Date

    /// Computed property: returns the number of entries this summary covers
    var entryCount: Int {
        includedIDs.count
    }

    /// Optional tags for theming or symbol metadata (e.g. ["rebirth", "transition", "loss"])
    var tags: [String]?

    /// Optional emotion gradient (e.g. extracted from journal tone analysis)
    var emotionalTone: String?

    init(
        id: UUID = UUID(),
        period: String,
        summaryText: String,
        includedIDs: [UUID],
        lastUpdated: Date = Date(),
        tags: [String]? = nil,
        emotionalTone: String? = nil
    ) {
        self.id = id
        self.period = period
        self.summaryText = summaryText
        self.includedIDs = includedIDs
        self.lastUpdated = lastUpdated
        self.tags = tags
        self.emotionalTone = emotionalTone
    }

    // MARK: - MemorySummaryService

/// Service responsible for generating, retrieving, and managing `MemorySummary` objects.
/// These summaries act as seasonal reflections and fast-recall caches.
final class MemorySummaryService {
    // In-memory store (swap with persistence layer later)
    private var summaries: [MemorySummary] = []

    // MARK: - Public API

    /// Returns all memory summaries
    func allSummaries() -> [MemorySummary] {
        summaries
    }

    /// Fetch summaries by period (e.g., "Spring 2025")
    func summaries(forPeriod period: String) -> [MemorySummary] {
        summaries.filter { $0.period == period }
    }

    /// Fetch summaries that contain any of the provided tags
    func summaries(matchingTags tags: [String]) -> [MemorySummary] {
        summaries.filter { summary in
            guard let summaryTags = summary.tags else { return false }
            return !Set(summaryTags).isDisjoint(with: tags)
        }
    }

    /// Create and store a new memory summary
    func createSummary(
        period: String,
        summaryText: String,
        includedIDs: [UUID],
        tags: [String]? = nil,
        emotionalTone: String? = nil
    ) {
        let summary = MemorySummary(
            period: period,
            summaryText: summaryText,
            includedIDs: includedIDs,
            tags: tags,
            emotionalTone: emotionalTone
        )
        summaries.append(summary)
    }
    /// Update an existing summary
    func updateSummary(
        id: UUID,
        updatedText: String? = nil,
        tags: [String]? = nil,
        emotionalTone: String? = nil
    ) {
        guard let index = summaries.firstIndex(where: { $0.id == id }) else { return }
        var summary = summaries[index]
        if let updatedText = updatedText { summary.summaryText = updatedText }
        if let tags = tags { summary.tags = tags }
        if let tone = emotionalTone { summary.emotionalTone = tone }
        summary.lastUpdated = Date()
        summaries[index] = summary
    }

    /// Placeholder for future archive behavior
    func archiveSummary(id: UUID) {
        print("Archived summary \(id)")
        // TODO: implement archival logic or long-term persistence
    }
}
}