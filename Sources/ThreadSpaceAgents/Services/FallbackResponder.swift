import Foundation

/// Responsible for generating fallback responses when no memory match is found.
/// Can vary tone and style depending on the user’s mood, time, or preference.
final class FallbackResponder {
    enum Tone {
        case gentle
        case playful
        case reflective
        case direct
        case poetic

        var prefix: String {
            switch self {
            case .gentle:
                return "Hmm... I couldn’t find anything right now."
            case .playful:
                return "🧐 My brain’s doing somersaults — nothing popped up!"
            case .reflective:
                return "As I reach inward... there's silence where memory should be."
            case .direct:
                return "No relevant memory found."
            case .poetic:
                return "The thread you seek slips through the loom of now."
            }
        }

        var suggestion: String {
            switch self {
            case .gentle:
                return "Would you like me to look deeper?"
            case .playful:
                return "Want me to dive into the vault and see what I dig up?"
            case .reflective:
                return "Shall I search the deeper wells of recall?"
            case .direct:
                return "Run a deeper search?"
            case .poetic:
                return "Shall I descend into the echoing archive?"
            }
        }
    }

    /// Returns a fallback message with tone customization.
    func generateFallback(for query: String, tone: Tone = .gentle) -> String {
        return """
        \(tone.prefix)
        \(tone.suggestion)
        """
    }
}