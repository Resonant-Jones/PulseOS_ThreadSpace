import SwiftUI
import SwiftData

struct JournalFeedView: View {
    @Query(sort: \.timestamp, order: .reverse) private var entries: [JournalEntry]

    var body: some View {
        NavigationStack {
            List(entries) { entry in
                JournalEntryView(entry: entry)
            }
            .navigationTitle("ThreadSpace Journal")
            .toolbar {
                NavigationLink(destination: NewJournalEntryView()) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
}