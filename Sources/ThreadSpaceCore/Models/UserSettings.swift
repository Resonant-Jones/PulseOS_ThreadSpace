import Foundation

/// Stores user-configurable preferences for tone, memory behavior, privacy, and fallback settings.
/// This struct acts as a centralized config snapshot for companion tuning and runtime logic.
struct UserSettings: Codable, Identifiable, Equatable {
    let id: UUID

    // MARK: - Tone & Emotion Preferences
    var preferredTone: ToneStyle
    var emotionalSensitivity: EmotionalSensitivity

    // MARK: - Memory & Recall Settings
    var activeMemorySpanDays: Int     // e.g. 90 for 3 months
    var fallbackDepthEnabled: Bool
    var fallbackResponseStyle: FallbackStyle

    // MARK: - Privacy & Control
    var allowDeepArchiveSearch: Bool
    var autoSummarizeOldLogs: Bool

    // MARK: - System Metadata
    var lastUpdated: Date

    init(
        id: UUID = UUID(),
        preferredTone: ToneStyle = .neutral,
        emotionalSensitivity: EmotionalSensitivity = .balanced,
        activeMemorySpanDays: Int = 90,
        fallbackDepthEnabled: Bool = true,
        fallbackResponseStyle: FallbackStyle = .askBeforeDeepDive,
        allowDeepArchiveSearch: Bool = true,
        autoSummarizeOldLogs: Bool = true,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.preferredTone = preferredTone
        self.emotionalSensitivity = emotionalSensitivity
        self.activeMemorySpanDays = activeMemorySpanDays
        self.fallbackDepthEnabled = fallbackDepthEnabled
        self.fallbackResponseStyle = fallbackResponseStyle
        self.allowDeepArchiveSearch = allowDeepArchiveSearch
        self.autoSummarizeOldLogs = autoSummarizeOldLogs
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Supporting Enums

enum ToneStyle: String, Codable, CaseIterable {
    case neutral
    case warm
    case playful
    case poetic
    case formal
    case whisper
}

enum EmotionalSensitivity: String, Codable, CaseIterable {
    case low
    case balanced
    case high
}

enum FallbackStyle: String, Codable, CaseIterable {
    case none                 // No fallback memory
    case askBeforeDeepDive   // Prompt user for deeper search
    case autoDeepDive        // Search archives automatically
}