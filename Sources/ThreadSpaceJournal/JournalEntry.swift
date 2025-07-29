import Foundation
import SwiftData

@Model
public final class JournalEntry: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date
    public var content: String
    public var moodScore: Double?  // Optional semantic score
    public var tags: [String]      // User- or AI-assigned keywords
    public var voiceNoteURL: URL?  // Path to associated audio file (if any)
    public var isArchived: Bool    // Flag for long-term memory

    // Relationships
    public var moodEntryID: UUID?  // Soft link to related MoodEntry (optional)

    // Init
    public init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        content: String,
        moodScore: Double? = nil,
        tags: [String] = [],
        voiceNoteURL: URL? = nil,
        isArchived: Bool = false,
        moodEntryID: UUID? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.content = content
        self.moodScore = moodScore
        self.tags = tags
        self.voiceNoteURL = voiceNoteURL
        self.isArchived = isArchived
        self.moodEntryID = moodEntryID
    }

    // MARK: - Computed Properties

    /// Shared date formatter for efficient reuse
    private static let sharedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    /// Friendly date string for UI sectioning
    public var dayString: String {
        Self.sharedDateFormatter.string(from: timestamp)
    }

    /// Short preview of the content
    public var previewText: String {
        content.prefix(100) + (content.count > 100 ? "…" : "")
    }

    /// Human-readable mood label
    public var moodDescription: String? {
        guard let score = moodScore else { return nil }
        switch score {
        case ..<0.3: return "Low"
        case 0.3..<0.6: return "Neutral"
        case 0.6...: return "Positive"
        default: return nil
        }
    }
}