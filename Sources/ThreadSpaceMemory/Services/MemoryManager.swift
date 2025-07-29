import Foundation

/// Singleton memory orchestrator responsible for loading, saving, and querying memory summaries.
/// Can be called from anywhere in the app (views, agents, services).
final class MemoryManager: ObservableObject {
    static let shared = MemoryManager()

    @Published private(set) var summaries: [MemorySummary] = []

    private let storageURL: URL

    private init() {
        let filename = "memory_summaries.json"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.storageURL = documentsURL.appendingPathComponent(filename)
        load()
    }

    // MARK: - Public API

    func load() {
        do {
            let data = try Data(contentsOf: storageURL)
            summaries = try JSONDecoder().decode([MemorySummary].self, from: data)
        } catch {
            print("[MemoryManager] Failed to load summaries: \(error.localizedDescription)")
            summaries = []
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(summaries)
            try data.write(to: storageURL)
        } catch {
            print("[MemoryManager] Failed to save summaries: \(error.localizedDescription)")
        }
    }

    func addSummary(_ summary: MemorySummary) {
        summaries.append(summary)
        save()
    }

    func updateSummary(_ updated: MemorySummary) {
        if let index = summaries.firstIndex(where: { $0.id == updated.id }) {
            summaries[index] = updated
            save()
        }
    }

    func summaries(forPeriod period: String) -> [MemorySummary] {
        summaries.filter { $0.period == period }
    }

    func summaries(matchingTags tags: [String]) -> [MemorySummary] {
        summaries.filter { summary in
            guard let summaryTags = summary.tags else { return false }
            return !Set(summaryTags).isDisjoint(with: tags)
        }
    }

    func archiveSummary(id: UUID) {
        print("[MemoryManager] Archived summary \(id)")
        // Hook for future archival logic
    }
}