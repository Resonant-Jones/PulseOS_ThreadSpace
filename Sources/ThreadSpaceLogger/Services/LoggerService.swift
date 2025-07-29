import Foundation
import os.log

// MARK: - LoggerService

public class LoggerService {

    private let logger = Logger(subsystem: "com.threadspace.logger", category: "LoggerService")
    private var logs: [LogEntry] = []
    private let embeddingManager: EmbeddingManager

    public init(embeddingManager: EmbeddingManager = EmbeddingManager()) {
        self.embeddingManager = embeddingManager
        logger.debug("LoggerService initialized.")
    }

    /// Logs a message with metadata and optional embedding
    public func log(
        message: String,
        type: LogEntry.EntryType = .info,
        tags: [String] = [],
        parentID: UUID? = nil,
        relatedIDs: [UUID] = [],
        source: String = "manual",
        isArchived: Bool = false,
        summary: String? = nil,
        generateEmbedding: Bool = true
    ) {
        let timestamp = Date()
        let embedding = generateEmbedding ? embeddingManager.generateEmbedding(from: message) : []

        let entry = LogEntry(
            id: UUID(),
            message: message,
            timestamp: timestamp,
            type: type,
            tags: tags,
            parentID: parentID,
            relatedIDs: relatedIDs,
            source: source,
            isArchived: isArchived,
            summary: summary,
            embedding: embedding
        )

        logs.append(entry)

        logger.log(level: mapLogType(type), "Logged message: \(message, privacy: .public)")
    }

    /// Retrieves logs filtered by tag
    public func getLogs(withTag tag: String) -> [LogEntry] {
        logs.filter { $0.tags.contains(tag) }
    }

    /// Retrieves logs by source
    public func getLogs(fromSource source: String) -> [LogEntry] {
        logs.filter { $0.source == source }
    }

    /// Retrieves only active (non-archived) logs
    public func getActiveLogs() -> [LogEntry] {
        logs.filter { !$0.isArchived }
    }

    /// Retrieves logs related to a specific parent ID
    public func getLogs(relatedTo parentID: UUID) -> [LogEntry] {
        logs.filter { $0.parentID == parentID || $0.relatedIDs.contains(parentID) }
    }

    /// Deep search (e.g., archived logs)
    public func deepDive(for keyword: String) -> [LogEntry] {
        return logs.filter {
            $0.isArchived &&
            ($0.message.contains(keyword) || $0.summary?.contains(keyword) == true)
        }
    }

    /// Clears all logs
    public func clearLogs() {
        logs.removeAll()
        logger.debug("All logs cleared.")
    }

    /// Returns a shallow copy of current logs
    public func getAllLogs() -> [LogEntry] {
        return logs
    }

    private func mapLogType(_ type: LogEntry.EntryType) -> OSLogType {
        switch type {
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .debug: return .debug
        }
    }
}