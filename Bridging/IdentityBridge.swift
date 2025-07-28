import Foundation

/// Swift wrapper for the Rust identity engine
/// Provides a clean, type-safe interface to the underlying Rust implementation
public class IdentityBridge {
    private static var isInitialized = false
    
    /// Initialize the Rust identity engine
    public static func initialize() {
        guard !isInitialized else { return }
        identity_init()
        isInitialized = true
    }
    
    /// Track a new intention from user prompt
    /// - Parameter prompt: The user's intention statement
    /// - Returns: Intention object with parsed data
    public static func trackIntention(from prompt: String) -> Intention? {
        guard let cString = prompt.cString(using: .utf8) else { return nil }
        
        let resultPtr = identity_track_intention(cString)
        defer { identity_free_string(resultPtr) }
        
        guard let resultPtr = resultPtr,
              let jsonString = String(cString: resultPtr, encoding: .utf8) else { return nil }
        
        let jsonData = Data(jsonString.utf8)
        return try? JSONDecoder().decode(Intention.self, from: jsonData)
    }
    
    /// Detect friction from behavior patterns
    /// - Parameters:
    ///   - intentID: The ID of the related intention
    ///   - behaviorType: Type of behavior (abandoned, delayed, inconsistent, completed)
    ///   - duration: Duration in seconds
    ///   - delay: Delay in seconds
    ///   - frequency: Frequency of behavior (0.0 to 1.0)
    /// - Returns: Friction object if detected
    public static func detectFriction(
        intentID: String,
        behaviorType: BehaviorType,
        duration: UInt64,
        delay: UInt64,
        frequency: Double
    ) -> Friction? {
        guard let cIntentID = intentID.cString(using: .utf8) else { return nil }
        
        let resultPtr = identity_detect_friction(
            cIntentID,
            behaviorType.rawValue,
            duration,
            delay,
            frequency
        )
        defer { identity_free_string(resultPtr) }
        
        guard let resultPtr = resultPtr,
              let jsonString = String(cString: resultPtr, encoding: .utf8) else { return nil }
        
        let jsonData = Data(jsonString.utf8)
        return try? JSONDecoder().decode(Friction.self, from: jsonData)
    }
    
    /// Get intention shift suggestions based on identity alignment
    /// - Returns: Array of suggestions for intention redirection
    public static func suggestIntentionShift() -> [Suggestion] {
        let resultPtr = identity_suggest_intention_shift()
        defer { identity_free_string(resultPtr) }
        
        guard let resultPtr = resultPtr,
              let jsonString = String(cString: resultPtr, encoding: .utf8) else { return [] }
        
        let jsonData = Data(jsonString.utf8)
        return (try? JSONDecoder().decode([Suggestion].self, from: jsonData)) ?? []
    }
}

// MARK: - Data Models

/// Represents a user intention with emotional context
public struct Intention: Codable {
    public let id: String
    public let summary: String
    public let tags: [String]
    public let urgencyScore: Double
    public let activationScore: Double
    public let createdAt: String
    public let lastTouched: String
    public let progress: Double
    public let isCompleted: Bool
    
    public init(
        id: String,
        summary: String,
        tags: [String],
        urgencyScore: Double,
        activationScore: Double,
        createdAt: String,
        lastTouched: String,
        progress: Double,
        isCompleted: Bool
    ) {
        self.id = id
        self.summary = summary
        self.tags = tags
        self.urgencyScore = urgencyScore
        self.activationScore = activationScore
        self.createdAt = createdAt
        self.lastTouched = lastTouched
        self.progress = progress
        self.isCompleted = isCompleted
    }
}

/// Represents detected friction in behavior patterns
public struct Friction: Codable {
    public let id: String
    public let summary: String
    public let cause: String
    public let linkedIntentID: String
    public let impactScore: Double
    public let detectedAt: String
    
    public init(
        id: String,
        summary: String,
        cause: String,
        linkedIntentID: String,
        impactScore: Double,
        detectedAt: String
    ) {
        self.id = id
        self.summary = summary
        self.cause = cause
        self.linkedIntentID = linkedIntentID
        self.impactScore = impactScore
        self.detectedAt = detectedAt
    }
}

/// Represents behavior patterns for friction detection
public enum BehaviorType: UInt32 {
    case abandoned = 0
    case delayed = 1
    case inconsistent = 2
    case completed = 3
}

/// Represents a suggestion for intention redirection
public struct Suggestion: Codable {
    public let originalIntent: Intention
    public let failureRate: Double
    public let identityAlignment: Double
    public let alternatives: [AlternativeIntent]
    
    public init(
        originalIntent: Intention,
        failureRate: Double,
        identityAlignment: Double,
        alternatives: [AlternativeIntent]
    ) {
        self.originalIntent = originalIntent
        self.failureRate = failureRate
        self.identityAlignment = identityAlignment
        self.alternatives = alternatives
    }
}

/// Represents an alternative intention aligned with identity
public struct AlternativeIntent: Codable {
    public let summary: String
    public let alignmentScore: Double
    public let identityNodeID: String
    
    public init(
        summary: String,
        alignmentScore: Double,
        identityNodeID: String
    ) {
        self.summary = summary
        self.alignmentScore = alignmentScore
        self.identityNodeID = identityNodeID
    }
}

/// Behavior log for friction detection
public struct BehaviorLog {
    public let id: String
    public let intentID: String
    public let behaviorType: BehaviorType
    public let durationSeconds: UInt64
    public let delaySeconds: UInt64
    public let frequency: Double
    
    public init(
        id: String,
        intentID: String,
        behaviorType: BehaviorType,
        durationSeconds: UInt64,
        delaySeconds: UInt64,
        frequency: Double
    ) {
        self.id = id
        self.intentID = intentID
        self.behaviorType = behaviorType
        self.durationSeconds = durationSeconds
        self.delaySeconds = delaySeconds
        self.frequency = frequency
    }
}

// MARK: - C Function Declarations

@_silgen_name("identity_init")
private func identity_init()

@_silgen_name("identity_track_intention")
private func identity_track_intention(_ prompt: UnsafePointer<CChar>?) -> UnsafeMutablePointer<CChar>?

@_silgen_name("identity_detect_friction")
private func identity_detect_friction(
    _ intent_id: UnsafePointer<CChar>?,
    _ behavior_type: UInt32,
    _ duration: UInt64,
    _ delay: UInt64,
    _ frequency: Double
) -> UnsafeMutablePointer<CChar>?

@_silgen_name("identity_suggest_intention_shift")
private func identity_suggest_intention_shift() -> UnsafeMutablePointer<CChar>?

@_silgen_name("identity_free_string")
private func identity_free_string(_ ptr: UnsafeMutablePointer<CChar>?)
