import ThreadSpaceMemory

class MemoryService: ObservableObject {
 @Published private(set) var activeMemories: [MemoryEntry] = []
 @Published private(set) var archivedMemories: [MemoryEntry] = []

 func searchMemories(query: String) -> [MemoryEntry] {
 return activeMemories.filter { $0.content.localizedCaseInsensitiveContains(query) }
 }

 func relatedMemories(to memory: MemoryEntry) -> [MemoryEntry] {
 return activeMemories.filter { $0.parentID == memory.id }
 }
}
