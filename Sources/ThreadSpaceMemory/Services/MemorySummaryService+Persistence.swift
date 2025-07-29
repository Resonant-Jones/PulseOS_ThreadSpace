import Foundation

extension MemorySummaryService {

    // MARK: - Default file path
    private var defaultSavePath: URL {
        let manager = FileManager.default
        let directory = manager.urls(for: .documentDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("memory_summaries.json")
    }

    // MARK: - Save to Disk
    func saveSummaries(to url: URL? = nil) {
        let saveURL = url ?? defaultSavePath
        do {
            let data = try JSONEncoder().encode(summaries)
            try data.write(to: saveURL, options: .atomic)
            print("✅ Memory summaries saved to: \(saveURL.lastPathComponent)")
        } catch {
            print("❌ Failed to save summaries: \(error.localizedDescription)")
        }
    }

    // MARK: - Load from Disk
    func loadSummaries(from url: URL? = nil) {
        let loadURL = url ?? defaultSavePath
        do {
            let data = try Data(contentsOf: loadURL)
            let loaded = try JSONDecoder().decode([MemorySummary].self, from: data)
            self.summaries = loaded
            print("✅ Memory summaries loaded from disk.")
        } catch {
            print("⚠️ No existing summaries found or failed to load: \(error.localizedDescription)")
        }
    }
}