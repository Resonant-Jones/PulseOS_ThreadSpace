 1. 📁 File Map — a clear tree of key files/modules
 2. 🧭 Intention Map — what each major component is for (philosophically and architecturally)

⸻

# 🧠 KimiBox Prompt Anchor: ThreadSpace Memory Cohesion

This file exists to give Kimi (or any coding agent) a complete overview of the architecture, file layout, and narrative purpose of the **ThreadSpaceMemory** system within PulseOS.

---

## 📁 File Map: `PulseOS_ThreadSpace/Sources/ThreadSpaceMemory/`

ThreadSpaceMemory/
├── Models/
│   ├── MemoryEntry.swift
│   ├── MoodEntry.swift
│   ├── JournalEntry.swift
│   └── MemorySummary.swift
│
├── Services/
│   ├── MemoryService.swift
│   ├── MemoryIngestionService.swift
│   ├── MemorySummaryService.swift
│   └── CompanionResponder.swift
│
├── Compiler/
│   └── PromptCompiler.swift
│
├── Support/
│   ├── UserSettings.swift
│   └── InjectionExtensions.swift

## 🧪 Tests: `PulseOS_ThreadSpace/Tests/ThreadSpaceMemoryTests/`

ThreadSpaceMemoryTests/
├── MemoryServiceTests.swift
├── MemoryIngestionServiceTests.swift
├── CompanionResponderTests.swift
├── PromptCompilerTests.swift
└── MoodAndJournalTests.swift

---

## 🧭 Intention Map: Narrative & Functional Purpose

### 🧠 `MemoryEntry.swift`
>
> Represents a single unit of remembered content (like an AI journal cell). Acts as the core memory atom in the system.

### 🎭 `MoodEntry.swift` / `JournalEntry.swift`
>
> Track emotional state and inner narrative, contributing to semantic context and emotional mirroring.

### 🌀 `MemorySummary.swift`
>
> Monthly or seasonal reflective summaries. Used for pattern awareness, mood trends, and memory compression.

---

### 🔍 `MemoryService.swift`
>
> Core retrieval engine. Will support:

- fuzzy search
- tag and parent traversal
- deep archive recall
- eventually: vector lookup

### 🪶 `MemoryIngestionService.swift`
>
> Lightweight ingest layer to append memory entries programmatically or via UI.

### 🧭 `CompanionResponder.swift`
>
> The bridge between AI and memory: chooses whether to surface a memory or fall back to symbolic generation.

### 🧙‍♂️ `PromptCompiler.swift`
>
> Generates symbolic, ritualized language based on context and scenario.

- Injects emotional tone
- Merges memory snippets
- Guides AI voice

---

### ⚙️ `UserSettings.swift`
>
> Tracks user tone/style preferences and fallback mode. Tunable for resonance and mood alignment.

### ✨ `InjectionExtensions.swift`
>
> Adds helper logic for emotional tone, fallback phrasing, and message formatting.

---

## 🧪 Testing Philosophy

Each core service has a dedicated test file, including:

- Companion-to-memory routing logic
- Tone injection behavior
- Journal/mood interactions
- Summary generation logic

---

## 🌌 Future Expansion

- `ThreadVault`: persistent long-term semantic memory
- `DreamCache`: dreamlike memory states and surreal interactions
- `ArchetypeMirror`: symbolic pattern classifier

---

> 💡 **Note for Kimi and future agents:** Preserve emotional coherence and symbolic clarity when refactoring. Every component here supports the user’s goal of semantic sovereignty and mythic journaling. Don't reduce this to CRUD — this is cognitive architecture.

Would you like a version of this saved into the file system? Or want to expand it with contributor notes and a changelog?
