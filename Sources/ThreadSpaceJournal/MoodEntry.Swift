import Foundation
import SwiftData

@Model
public final class MoodEntry: Identifiable, Codable {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date
    public var moodScore: Double  // Range: -1.0 (low) to +1.0 (high)
    public var tag: String        // e.g., "anxious", "grateful", "focused"
    public var note: String?      // Optional user reflection

    // MARK: - Init

    public init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        moodScore: Double,
        tag: String,
        note: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.moodScore = moodScore
        self.tag = tag
        self.note = note
    }

    // MARK: - Static Formatter

    private static let sharedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    // MARK: - Computed Properties

    /// Readable date for UI grouping
    public var dayString: String {
        Self.sharedDateFormatter.string(from: timestamp)
    }

    /// Friendly description based on mood score
    public var moodDescription: String {
        switch moodScore {
        case ..<(-0.5): return "Very Low"
        case -0.5..<0.0: return "Low"
        case 0.0..<0.5: return "Neutral"
        case 0.5...: return "Positive"
        default: return "Unknown"
        }
    }

    /// Whether user left a note
    public var hasNote: Bool {
        return (note?.isEmpty == false)
    }

    /// Optional mood category for clustering
    public var moodGroupTag: String {
        switch moodScore {
        case ..<(-0.3): return "negative"
        case -0.3..<0.3: return "neutral"
        case 0.3...: return "positive"
        default: return "undefined"
        }
    }
}