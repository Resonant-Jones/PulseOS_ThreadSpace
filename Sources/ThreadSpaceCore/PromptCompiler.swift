import Foundation

enum PromptScenario {
 case ritual
}

struct PromptConfiguration {
 let preamble: String
 let intentInstruction: String
}

func promptConfiguration(for scenario: PromptScenario) -> PromptConfiguration {
 switch scenario {
 case .ritual:
 return PromptConfiguration(
 preamble: "You're a ceremonial guide helping the user enter sacred space and symbolic clarity.",
 intentInstruction: "Frame the interaction as a meaningful ritual. Use symbolic language when appropriate."
 )
 }
}

struct Prompt {
 let preamble: String
 let intentInstruction: String
 let memorySnippet: String?
}

func compilePrompt(for scenario: PromptScenario, using memory: MemoryEntry?) -> Prompt {
 let config = promptConfiguration(for: scenario)
 let memorySnippet = memory.map { "\($0.content)" }
 return Prompt(
 preamble: config.preamble,
 intentInstruction: config.intentInstruction,
 memorySnippet: memorySnippet
 )
}
