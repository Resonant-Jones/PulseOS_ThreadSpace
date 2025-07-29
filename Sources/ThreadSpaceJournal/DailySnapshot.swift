import Foundation
import SwiftData

@Model
public final class DailySnapshot: Identifiable {
    @Attribute(.unique) public var id: UUID
    public var date: Date

    // Health metrics
    public var steps: Int?
    public var heartRate: Double?
    public var hrv: Double?  // Heart Rate Variability
    public var sleepHours: Double?
    public var exerciseMinutes: Double?

    // Self-reported mood & tags
    public var moodScore: Double? // -1.0 (low) to +1.0 (high)
    public var gratitudeNote: String?
    public var stressLevel: Double?

    // Linked journal summary
    public var summary: String?

    // Initialization
    public init(
        id: UUID = UUID(),
        date: Date = .now,
        steps: Int? = nil,
        heartRate: Double? = nil,
        hrv: Double? = nil,
        sleepHours: Double? = nil,
        exerciseMinutes: Double? = nil,
        moodScore: Double? = nil,
        gratitudeNote: String? = nil,
        stressLevel: Double? = nil,
        summary: String? = nil
    ) {
        self.id = id
        self.date = date
        self.steps = steps
        self.heartRate = heartRate
        self.hrv = hrv
        self.sleepHours = sleepHours
        self.exerciseMinutes = exerciseMinutes
        self.moodScore = moodScore
        self.gratitudeNote = gratitudeNote
        self.stressLevel = stressLevel
        self.summary = summary
    }
}