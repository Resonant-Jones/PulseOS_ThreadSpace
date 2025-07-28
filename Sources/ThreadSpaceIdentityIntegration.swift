import Foundation
import SwiftUI
import IdentityBridge

/// ThreadSpace Identity Integration
/// Provides seamless integration between the Rust identity engine and SwiftUI components
/// Handles the complete identity tracking pipeline for HOTBOX functionality
public class ThreadSpaceIdentityIntegration: ObservableObject {
    @Published public var intentions: [IdentityBridge.Intention] = []
    @Published public var friction: [IdentityBridge.Friction] = []
    @Published public var suggestions: [IdentityBridge.Suggestion] = []
    
    private let identityBridge = IdentityBridge.self
    
    public init() {
        identityBridge.initialize()
    }
    
    // MARK: - Intention Tracking
    
    /// Track a new intention from user input
    /// - Parameter prompt: User's intention statement
    public func trackIntention(_ prompt: String) {
        Task {
            if let intention = await identityBridge.trackIntention(from: prompt) {
                await MainActor.run {
                    self.intentions.append(intention)
                }
            }
        }
    }
    
    /// Track intention from journal entry
    /// - Parameter entry: Journal entry with emotional context
    public func trackIntention(from entry: JournalEntry) {
        let prompt = "I want to \(entry.title.lowercased()) - \(entry.content.prefix(50))"
        trackIntention(prompt)
    }
    
    /// Track intention from health context
    /// - Parameter healthData: Health snapshot data
    public func trackIntention(from healthData: HealthSnapshot) {
        let prompt = "I want to improve my health - steps: \(healthData.steps), energy: \(healthData.activeEnergy)"
        trackIntention(prompt)
    }
    
    // MARK: - Friction Detection
    
    /// Detect friction from behavior patterns
    /// - Parameters:
    ///   - intentID: Related intention ID
    ///   - behavior: Behavior pattern
    public func detectFriction(
        intentID: String,
        behavior: BehaviorPattern
    ) {
        Task {
            if let friction = await identityBridge.detectFriction(
                intentID: intentID,
                behaviorType: behavior.type,
                duration: behavior.duration,
                delay: behavior.delay,
                frequency: behavior.frequency
            ) {
                await MainActor.run {
                    self.friction.append(friction)
                }
            }
        }
    }
    
    /// Detect friction from app usage patterns
    /// - Parameters:
    ///   - intentID: Related intention ID
    ///   - usage: App usage pattern
    public func detectFriction(
        intentID: String,
        usage: AppUsagePattern
    ) {
        let behaviorType: IdentityBridge.BehaviorType
        switch usage.pattern {
        case .abandoned:
            behaviorType = .abandoned
        case .delayed:
            behaviorType = .delayed
        case .inconsistent:
            behaviorType = .inconsistent
        case .completed:
            behaviorType = .completed
        }
        
        detectFriction(
            intentID: intentID,
            behavior: BehaviorPattern(
                type: behaviorType,
                duration: usage.duration,
                delay: usage.delay,
                frequency: usage.frequency
            )
        )
    }
    
    // MARK: - Suggestion Generation
    
    /// Generate intention shift suggestions
    public func generateSuggestions() {
        Task {
            let newSuggestions = await identityBridge.suggestIntentionShift()
            await MainActor.run {
                self.suggestions = newSuggestions
            }
        }
    }
    
    // MARK: - Convenience Methods
    
    /// Get all active intentions (not completed)
    public var activeIntentions: [IdentityBridge.Intention] {
        intentions.filter { !$0.isCompleted }
    }
    
    /// Get completed intentions
    public var completedIntentions: [IdentityBridge.Intention] {
        intentions.filter { $0.isCompleted }
    }
    
    /// Get friction for a specific intention
    /// - Parameter intentID: Intention ID
    /// - Returns: Array of friction events
    public func friction(for intentID: String) -> [IdentityBridge.Friction] {
        friction.filter { $0.linkedIntentID == intentID }
    }
    
    /// Get suggestions for a specific intention
    /// - Parameter intentID: Intention ID
    /// - Returns: Suggestion if available
    public func suggestion(for intentID: String) -> IdentityBridge.Suggestion? {
        suggestions.first { $0.originalIntent.id == intentID }
    }
    
    // MARK: - HOTBOX Integration
    
    /// Process user reflection and update identity
    /// - Parameter reflection: User's reflective statement
    public func processUserReflection(_ reflection: String) {
        trackIntention(reflection)
    }
    
    /// Process behavior and detect friction
    /// - Parameters:
    ///   - intentID: Related intention
    ///   - behavior: Behavior pattern
    public func processBehavior(
        intentID: String,
        behavior: BehaviorPattern
    ) {
        detectFriction(intentID: intentID, behavior: behavior)
        generateSuggestions()
    }
    
    /// Get identity insights for display
    /// - Returns: Identity insights summary
    public func getIdentityInsights() -> IdentityInsights {
        let activeCount = activeIntentions.count
        let completedCount = completedIntentions.count
        let totalFriction = friction.count
        
        let highPriorityIntentions = activeIntentions.filter { $0.urgencyScore > 0.7 }
        let identityAlignedIntentions = activeIntentions.filter { $0.activationScore > 0.6 }
        
        return IdentityInsights(
            activeIntentions: activeCount,
            completedIntentions: completedCount,
            totalFriction: totalFriction,
            highPriorityIntentions: highPriorityIntentions.count,
            identityAlignedIntentions: identityAlignedIntentions.count,
            suggestions: suggestions.count
        )
    }
}

// MARK: - Supporting Data Models

/// Journal entry for intention tracking
public struct JournalEntry {
    public let id: String
    public let title: String
    public let content: String
    public let mood: String
    public let date: Date
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        content: String,
        mood: String,
        date: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.mood = mood
        self.date = date
    }
}

/// Health snapshot for intention tracking
public struct HealthSnapshot {
    public let id: String
    public let steps: Int
    public let activeEnergy: Double
    public let sleepHours: Double
    public let date: Date
    
    public init(
        id: String = UUID().uuidString,
        steps: Int,
        activeEnergy: Double,
        sleepHours: Double,
        date: Date = Date()
    ) {
        self.id = id
        self.steps = steps
        self.activeEnergy = activeEnergy
        self.sleepHours = sleepHours
        self.date = date
    }
}

/// Behavior pattern for friction detection
public struct BehaviorPattern {
    public let type: IdentityBridge.BehaviorType
    public let duration: UInt64
    public let delay: UInt64
    public let frequency: Double
    
    public init(
        type: IdentityBridge.BehaviorType,
        duration: UInt64,
        delay: UInt64,
        frequency: Double
    ) {
        self.type = type
        self.duration = duration
        self.delay = delay
        self.frequency = frequency
    }
}

/// App usage pattern for friction detection
public struct AppUsagePattern {
    public let pattern: UsagePattern
    public let duration: UInt64
    public let delay: UInt64
    public let frequency: Double
    
    public init(
        pattern: UsagePattern,
        duration: UInt64,
        delay: UInt64,
        frequency: Double
    ) {
        self.pattern = pattern
        self.duration = duration
        self.delay = delay
        self.frequency = frequency
    }
}

/// Usage pattern types
public enum UsagePattern {
    case abandoned
    case delayed
    case inconsistent
    case completed
}

/// Identity insights summary
public struct IdentityInsights {
    public let activeIntentions: Int
    public let completedIntentions: Int
    public let totalFriction: Int
    public let highPriorityIntentions: Int
    public let identityAlignedIntentions: Int
    public let suggestions: Int
    
    public init(
        activeIntentions: Int,
        completedIntentions: Int,
        totalFriction: Int,
        highPriorityIntentions: Int,
        identityAlignedIntentions: Int,
        suggestions: Int
    ) {
        self.activeIntentions = activeIntentions
        self.completedIntentions = completedIntentions
        self.totalFriction = totalFriction
        self.highPriorityIntentions = highPriorityIntentions
        self.identityAlignedIntentions = identityAlignedIntentions
        self.suggestions = suggestions
    }
}

// MARK: - SwiftUI Integration Extensions

extension ThreadSpaceIdentityIntegration {
    /// SwiftUI view for displaying intentions
    public var intentionsView: some View {
        List(activeIntentions) { intention in
            VStack(alignment: .leading) {
                Text(intention.summary)
                    .font(.headline)
                HStack {
                    ForEach(intention.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(4)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
                ProgressView(value: intention.progress)
                HStack {
                    Text("Urgency: \(Int(intention.urgencyScore * 100))%")
                        .font(.caption)
                    Spacer()
                    Text("Activation: \(Int(intention.activationScore * 100))%")
                        .font(.caption)
                }
            }
        }
    }
    
    /// SwiftUI view for displaying friction
    public var frictionView: some View {
        List(friction) { friction in
            VStack(alignment: .leading) {
                Text(friction.summary)
                    .font(.headline)
                Text("Cause: \(friction.cause)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Impact: \(Int(friction.impactScore * 100))%")
                    .font(.caption)
            }
        }
    }
    
    /// SwiftUI view for displaying suggestions
    public var suggestionsView: some View {
        List(suggestions) { suggestion in
            VStack(alignment: .leading) {
                Text("Original: \(suggestion.originalIntent.summary)")
                    .font(.headline)
                Text("Failure Rate: \(Int(suggestion.failureRate * 100))%")
                    .font(.caption)
                ForEach(suggestion.alternatives) { alternative in
                    Text("Alternative: \(alternative.summary)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
