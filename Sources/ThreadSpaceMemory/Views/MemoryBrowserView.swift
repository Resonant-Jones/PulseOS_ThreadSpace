import SwiftUI

struct MemoryBrowserView: View {
    @ObservedObject var memoryService: MemoryService
    
    var body: some View {
        List(memoryService.activeMemories) { memory in
            VStack(alignment: .leading) {
                Text(memory.content).font(.body)
                Text(memory.timestamp, style: .date).font(.caption)
            }
        }
    }
}