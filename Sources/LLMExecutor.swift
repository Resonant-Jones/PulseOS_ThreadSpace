import Foundation

/// LLM Executor
/// Unified interface for executing local LLMs
actor LLMExecutor {
    // MARK: - Execution

    /// Execute a prompt request with a given model
    /// - Parameters:
    /// - request: The prompt request to execute
    /// - Returns: LLM response
    func execute(request: PromptRequest) async throws -> LLMResponse {
        // Implement execution logic here
        return LLMResponse(text: "", usage: 0)
    }

    // MARK: - Data Models

    /// Prompt request model
    struct PromptRequest {
        let userMessage: String
        let systemPrompt: String?
        let maxTokens: Int
    }

    /// LLM response model
    struct LLMResponse {
        let text: String
        let usage: Int
    }
}
