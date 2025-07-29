import Foundation
import SwiftData

public enum LogEntryType: String, Codable, CaseIterable {
    case journal
    case conversation
    case event
    case audioNote
    case fileUpload
    case health
}

public enum LogEntrySource: String, Codable, CaseIterable {
    case user
    case ai
    case system
}

@Model
public final class LogEntry {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date

    public var type: LogEntryType
    public var content: String
    public var tags: [String]

    public var source: LogEntrySource
    public var moodScore: Double?

    public var embeddingID: UUID?      // Links to vector DB
    public var mediaPath: String?      // Path to any attached image/audio
    public var archived: Bool

    public init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        type: LogEntryType,
        content: String,
        tags: [String] = [],
        source: LogEntrySource,
        moodScore: Double? = nil,
        embeddingID: UUID? = nil,
        mediaPath: String? = nil,
        archived: Bool = false
    ) {
        self.id = id
        self.timestamp = timestamp
        self.type = type
        self.content = content
        self.tags = tags
        self.source = source
        self.moodScore = moodScore
        self.embeddingID = embeddingID
        self.mediaPath = mediaPath
        self.archived = archived
    }
}