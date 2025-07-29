import ThreadSpaceMemory

class MemoryIngestionServiceImpl: ObservableObject {
 @Published private(set) var memoryEntries: [MemoryEntry] = []

 func ingestMemory(content: String, source: String, tags: [String] = [], parentID: UUID? = nil) -> MemoryEntry {
 let memory = MemoryEntry(content: content, source: source, tags: tags, parentID: parentID)
 memoryEntries.append(memory)
 return memory
 }

 func updateMemory(id: UUID, content: String) {
 if let index = memoryEntries.firstIndex(where: { $0.id == id }) {
 memoryEntries[index].content = content
 }
 }

 func deleteMemory(id: UUID) {
 memoryEntries.removeAll(where: { $0.id == id })
 }
}
