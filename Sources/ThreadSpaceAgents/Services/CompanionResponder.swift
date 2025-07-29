import Foundation
import ThreadSpaceMemory
import ThreadSpaceCore

/// The CompanionResponder acts as a bridge between user prompts and semantic memory retrieval.
/// It handles fuzzy memory lookup, fallback behaviors, and adaptive response construction.
final class CompanionResponder {
 private let memoryService: MemoryService
 private let fallbackResponder: FallbackResponder
 private let promptCompiler: PromptCompiler

 init(
 memoryService: MemoryService = MemoryService(),
 fallbackResponder: FallbackResponder = FallbackResponder(),
 promptCompiler: PromptCompiler = PromptCompiler()
 ) {
 self.memoryService = memoryService
 self.fallbackResponder = fallbackResponder
 self.promptCompiler = promptCompiler
 }

 /// Attempts to find a relevant memory entry matching the query.
 /// If none is found, it returns a fallback message, with tone support.
 func respond(to query: String, tone: FallbackResponder.Tone = .gentle) async -> String {
 if let memory = memoryService.activeMemories.first(where: { $0.content.localizedCaseInsensitiveContains(query) }) {
 let prompt = promptCompiler.compilePrompt(for: .ritual, using: memory)
 return prompt.preamble + "\n" + prompt.intentInstruction + "\nMemory Snippet: \(memory.content)"
 } else {
 return fallbackResponder.generateFallback(for: query, tone: tone)
 }
 }
}
