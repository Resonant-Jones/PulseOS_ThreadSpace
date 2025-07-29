import Foundation
import SwiftUI

@main
struct ThreadSpaceMemoryApp: App {
    @StateObject private var memoryService = MemorySummaryService()

    init() {
        // Optional: preload with mock/test data if empty
        if memoryService.allSummaries().isEmpty {
            memoryService.createSummary(
                period: "July 2025",
                summaryText: "ThreadSpace memory system initialized.",
                includedIDs: [],
                tags: ["bootstrap"],
                emotionalTone: "neutral"
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            MemoryDashboardView()
                .environmentObject(memoryService)
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    memoryService.saveSummaries()
                }
        }
    }
}