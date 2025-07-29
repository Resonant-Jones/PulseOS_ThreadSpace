func testFallbackWhenNoMemoryFound() async throws {
    // Arrange: No relevant memory injected
    let memoryService = MemoryService()
    let promptCompiler = PromptCompiler()
    let fallbackResponder = FallbackResponder()
    let responder = CompanionResponder(
        memoryService: memoryService,
        fallbackResponder: fallbackResponder,
        promptCompiler: promptCompiler
    )

    // Act: Ask the companion about something unknown
    let query = "dragonfruit"
    let response = await responder.respond(to: query, tone: .gentle)

    // Assert: Should fallback gracefully with appropriate tone
    XCTAssertTrue(response.localizedCaseInsensitiveContains("I’m not sure") || response.localizedCaseInsensitiveContains("curious"),
                  "Response should be a fallback when no memory matches.")
    XCTAssertTrue(response.contains(query), "Fallback should acknowledge the original query.")
}