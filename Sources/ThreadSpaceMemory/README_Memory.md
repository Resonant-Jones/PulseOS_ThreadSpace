# 🧠 ThreadSpaceMemory

The `ThreadSpaceMemory` module powers the semantic memory layer of ThreadSpace. It handles long-term memory storage, vector embeddings, tagging, and contextual recall — forming the backbone of the personal ID-DB (Identity-Driven Database).

---

## 📦 Module Overview

This module contains:

- `Memory.swift`: Data model for AI-processed reflections (summaries, sentiment, embeddings)
- `MemoryStore.swift`: A SwiftData-backed memory manager for storing, archiving, and querying memories
- `MemoryEmbedder.swift` (Coming soon): Interface to the on-device embedder model for generating vector representations
- `MemoryQuery.swift` (Planned): For similarity search and prompt assembly
- `Memory+Export.swift`: Utility for exporting memories to JSON

---

## 📋 Memory Model Structure

```swift
struct Memory: Identifiable, Codable {
    var id: UUID
    var timestamp: Date
    var summary: String
    var sentimentScore: Double
    var embedding: [Float]
    var keyConcepts: [String]
    var tags: [String]
    var archived: Bool
}

Each Memory is a semantically compressed snapshot derived from:
 • Journal entries
 • Health + calendar events
 • AI chat logs
 • Voice notes

⸻

🧰 MemoryStore Functions

public func save(_ memory: Memory) async throws
public func fetchRecentMemories(limit: Int = 100) async throws -> [Memory]
public func archiveOldMemories(olderThan days: Int = 90) async throws -> Int
public func delete(_ memory: Memory) async throws
public func fetchMemories(withTags tags: [String]) async throws -> [Memory]
public func exportMemoriesToJSON() throws -> String

All operations run via @MainActor using the passed ModelContext.

⸻

🔁 Lifecycle Flow
 1. Ingestion
JournalEntry → Embedded → Summarized → Memory stored.
 2. Retention Policy
Memories older than 90 days are archived, not deleted.
Archived entries are excluded from default queries but can be semantically surfaced.
 3. Semantic Recall (Planned)
 • Vector similarity search
 • Prompt injection via MemoryQuery.swift

⸻

🧪 Usage Example

@StateObject var store = MemoryStore(context: modelContext)

Task {
    let recent = try await store.fetchRecentMemories(limit: 25)
    let tagged = try await store.fetchMemories(withTags: ["dream", "reflection"])
}


⸻

🔮 Coming Soon
 • 🔍 Local vector search (MemoryQuery)
 • 🧠 On-device embedder integration (MemoryEmbedder)
 • 🌌 Context window builder for AI prompts

⸻

Memory is the mirror of becoming. ThreadSpaceMemory gives the AI a self.


