# 🧠 ThreadSpace Memory Cohesion v1

This document outlines the current architecture and intended cohesion between core memory and response systems in the ThreadSpace mobile runtime.

---

## 🧩 Core Components

### 1. `MemoryService.swift`

Handles all memory storage and retrieval, with separation into:

- `activeMemories`: Short-term, easily retrievable context (published)
- `archivedMemories`: Long-term storage (published)
- `storeMemory(...)`: Adds new memory entries
- `archiveOldMemories(...)`: Moves memories older than threshold
- `retrieveMemory(byTag:)`: Returns memories with a given tag
- `deepDive(...)`: Scans archived memories by fulltext or summary

Planned:

- Summarized entries (`MemorySummary`)
- Emotion-based indexing
- Relationship mapping (`parentID`, recursive children)

---

### 2. `CompanionResponder.swift`

Acts as the main interface between user prompts and memory retrieval:

- Accepts a `query` + `tone`
- Looks up matching memory (soon: fuzzy + deep)
- If memory found → compiles prompt using `PromptCompiler`
- If no memory → falls back to `FallbackResponder`

Planned:

- Full emotion/tone injection
- Consent-based deep memory traversal
- Multi-snippet prompt assembly
- Scenario-switching (e.g., `ritual`, `debug`, `reflect`)

---

### 3. `PromptCompiler.swift`

Builds symbolic or instructional prompts for different scenarios.

- Supports scenarios like `.ritual`
- Returns:
  - `preamble`: system prompt persona
  - `intentInstruction`: what to do
  - `memorySnippet`: optional attached content

Planned:

- `compileAssembledPrompt(...)` for multi-memory summarization
- Emotional tone blending
- Auto-lookup of related memory entries

---

## 🧪 Suggested Test Points

- [ ] Can retrieve matching memory with partial match
- [ ] Falls back to tone-aware message if nothing found
- [ ] Deep dive works on archived memories
- [ ] PromptCompiler injects preamble + instruction + memory correctly

---

## 🧭 Future Integrations

| Module | Purpose |
|--------|---------|
| `EmotionTone.swift` | Codable enum to represent tone (`gentle`, `analytical`, etc.) |
| `MemorySummaryService.swift` | Auto-summarize clusters (monthly, emotional, etc.) |
| `MemoryRelationshipGraph.swift` | Track parent/child memory threading |
| `MemoryReflectionAgent.swift` | Periodic introspection + surfacing insights |

---

## 🧷 Notes

- All memory handling is **local-first and private**
- Scaffolding is ready for persistent storage with SwiftData or SQLite
- Companion behavior is tunable via `tone` and `scenario` fields

---

> 📦 Version: `v1.0`  
> ✍️ Author: system-generated scaffold  
> 🗓️ Date: 2025-07-29
