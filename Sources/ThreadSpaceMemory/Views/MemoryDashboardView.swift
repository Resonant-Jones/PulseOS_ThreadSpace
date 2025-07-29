import SwiftUI

struct MemoryDashboardView: View {
    @EnvironmentObject var memoryService: MemorySummaryService

    var body: some View {
        NavigationView {
            List {
                ForEach(memoryService.allSummaries()) { summary in
                    VStack(alignment: .leading) {
                        Text(summary.period)
                            .font(.headline)
                        Text(summary.summaryText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Memory Summaries")
        }
    }
}