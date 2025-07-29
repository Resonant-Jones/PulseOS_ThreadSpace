import Foundation
import SwiftData

@Model
public final class Memory {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date

    public var summary: String
    public var keyConcepts: [String]
    public var sentimentScore: Double?
    public var embedding: Data?

    public var sourceLogIDs: [UUID]
    public var archived: Bool

    public init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        summary: String,
        keyConcepts: [String] = [],
        sentimentScore: Double? = nil,
        embedding: Data? = nil,
        sourceLogIDs: [UUID] = [],
        archived: Bool = false
    ) {
        self.id = id
        self.timestamp = timestamp
        self.summary = summary
        self.keyConcepts = keyConcepts
        self.sentimentScore = sentimentScore
        self.embedding = embedding
        self.sourceLogIDs = sourceLogIDs
        self.archived = archived
    }
}