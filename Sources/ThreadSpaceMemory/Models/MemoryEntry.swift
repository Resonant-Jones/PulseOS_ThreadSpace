import Foundation

struct MemoryEntry: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    var content: String
    var summary: String?
    var parentID: UUID?
    var tags: [String]
    var source: String // e.g. "journal", "log", "agent"
    var isArchived: Bool
    
    init(content: String, source: String, tags: [String] = [], parentID: UUID? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.content = content
        self.source = source
        self.tags = tags
        self.parentID = parentID
        self.isArchived = false
    }
}