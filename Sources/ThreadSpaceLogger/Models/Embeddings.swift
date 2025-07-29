// MARK: - Embedding Model

public struct Embedding: Codable, Identifiable {
    public let id: UUID
    public let vector: [Float]
    public var metadata: [String: String]
    public let timestamp: Date
    public let parentID: UUID?
    public var isArchived: Bool
    public var summary: String?

    // New fields
    public var source: String? // e.g., "journal", "voice", "health", etc.
    public var tags: [String]?
    public var relatedIDs: [UUID]? // for fuzzy clustering or event chains

    public init(
        vector: [Float],
        metadata: [String: String] = [:],
        timestamp: Date = .now,
        parentID: UUID? = nil,
        isArchived: Bool = false,
        summary: String? = nil,
        source: String? = nil,
        tags: [String]? = nil,
        relatedIDs: [UUID]? = nil
    ) {
        self.id = UUID()
        self.vector = vector
        self.metadata = metadata
        self.timestamp = timestamp
        self.parentID = parentID
        self.isArchived = isArchived
        self.summary = summary
        self.source = source
        self.tags = tags
        self.relatedIDs = relatedIDs
    }
}