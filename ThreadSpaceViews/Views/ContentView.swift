import SwiftUI

struct ContentView: View {
    enum Tab {
        case companion, logger, mood, journal, settings
    }

    @State private var selectedTab: Tab = .companion

    var body: some View {
        TabView(selection: $selectedTab) {
            CompanionView()
                .tabItem {
                    Label("Companion", systemImage: "sparkles")
                }
                .tag(Tab.companion)

            LoggerView()
                .tabItem {
                    Label("Logger", systemImage: "pencil.and.ellipsis.rectangle")
                }
                .tag(Tab.logger)

            MoodView()
                .tabItem {
                    Label("Mood", systemImage: "face.smiling")
                }
                .tag(Tab.mood)

            JournalLogView()
                .tabItem {
                    Label("Journal", systemImage: "book.closed")
                }
                .tag(Tab.journal)
            

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
    }
}
#Preview {
    ContentView()
}
