// ThreadSpaceMemory/MemoryStore.swift

import Foundation
import SwiftData

@MainActor
public class MemoryStore: ObservableObject {
    private let context: ModelContext

    public init(context: ModelContext) {
        self.context = context
    }

    public func save(_ memory: Memory) async throws {
        context.insert(memory)
        try context.save()
    }

    public func fetchRecentMemories(limit: Int = 100) async throws -> [Memory] {
        let descriptor = FetchDescriptor<Memory>(
            sortBy: [.init(\.timestamp, order: .reverse)],
            predicate: #Predicate { !$0.archived }
        )
        return try context.fetch(descriptor).prefix(limit).map { $0 }
    }

    public func archiveOldMemories(olderThan days: Int = 90) async throws {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: .now)!
        let predicate = #Predicate<Memory> { $0.timestamp < cutoff && !$0.archived }
        let toArchive = try context.fetch(FetchDescriptor(predicate: predicate))

        for memory in toArchive {
            memory.archived = true
        }
        try context.save()
    }

    public func delete(_ memory: Memory) async throws {
        context.delete(memory)
        try context.save()
    }
}