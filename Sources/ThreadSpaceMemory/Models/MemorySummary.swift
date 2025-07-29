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
}