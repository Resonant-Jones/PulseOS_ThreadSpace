import Foundation
import Accelerate

// MARK: - Embedding Model

public struct Embedding: Codable, Identifiable {
    public let id: UUID
    public let vector: [Float]
    public let metadata: [String: String]
    
    public init(vector: [Float], metadata: [String: String] = [:]) {
        self.id = UUID()
        self.vector = vector
        self.metadata = metadata
    }
}

// MARK: - VectorStore

public final class VectorStore {
    private var embeddings: [Embedding] = []

    public init(initialEmbeddings: [Embedding] = []) {
        self.embeddings = initialEmbeddings
    }

    /// Store a new embedding
    public func store(_ embedding: Embedding) {
        embeddings.append(embedding)
    }

    /// Search for top K similar vectors using cosine similarity
    public func search(for query: [Float], topK: Int = 5) -> [Embedding] {
        guard !embeddings.isEmpty else { return [] }

        let results = embeddings
            .map { ($0, cosineSimilarity(query, $0.vector)) }
            .sorted { $0.1 > $1.1 }
            .prefix(topK)
            .map { $0.0 }

        return Array(results)
    }

    /// Persist embeddings to disk (JSON-based, simple for now)
    public func save(to url: URL) throws {
        let data = try JSONEncoder().encode(embeddings)
        try data.write(to: url)
    }

    /// Load persisted embeddings
    public func load(from url: URL) throws {
        let data = try Data(contentsOf: url)
        self.embeddings = try JSONDecoder().decode([Embedding].self, from: data)
    }

    /// Utility: cosine similarity between two vectors
    private func cosineSimilarity(_ a: [Float], _ b: [Float]) -> Float {
        guard a.count == b.count else { return -1 }

        var dot: Float = 0
        var normA: Float = 0
        var normB: Float = 0

        for i in 0..<a.count {
            dot += a[i] * b[i]
            normA += a[i] * a[i]
            normB += b[i] * b[i]
        }

        let denominator = sqrt(normA) * sqrt(normB)
        return denominator != 0 ? dot / denominator : 0
    }
    // Search only active memory
public func searchActiveMemory(
    for query: [Float],
    topK: Int = 5,
    filter: ((Embedding) -> Bool)? = nil
) -> [Embedding] {
    return search(
        for: query,
        topK: topK,
        filter: { !$0.isArchived && (filter?($0) ?? true) }
    )
}

// Search only archived memory
public func searchArchivedMemory(
    for query: [Float],
    topK: Int = 5
) -> [Embedding] {
    return search(for: query, topK: topK, filter: { $0.isArchived })
}

// Internal: search with optional filter and future decay logic
private func search(
    for query: [Float],
    topK: Int,
    filter: ((Embedding) -> Bool)? = nil
) -> [Embedding] {
    guard !embeddings.isEmpty else { return [] }

    let results = embeddings
        .filter { filter?($0) ?? true }
        .map { embedding in
            let similarity = cosineSimilarity(query, embedding.vector)
            return (embedding, similarity)
        }
        .sorted { $0.1 > $1.1 }
        .prefix(topK)
        .map { $0.0 }

    return Array(results)
}
}