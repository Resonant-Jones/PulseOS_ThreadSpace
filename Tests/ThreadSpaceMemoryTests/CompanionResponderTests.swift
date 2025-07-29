func testMemoryLookupAndResponse() async throws {
    // Arrange: Create a mock memory and inject it into the memory service
    let mockMemory = MemoryEntry(content: "I walked through the ancient forest, listening to the whispers of the trees.", source: "journal")
    let memoryService = MemoryService()
    memoryService.activeMemories.append(mockMemory)
    
    // Create the responder with dependencies
    let promptCompiler = PromptCompiler()
    let fallbackResponder = FallbackResponder()
    let responder = CompanionResponder(
        memoryService: memoryService,
        fallbackResponder: fallbackResponder,
        promptCompiler: promptCompiler
    )

    // Act: Ask the companion about the forest
    let response = await responder.respond(to: "forest", tone: .gentle)

    // Assert: The response should reflect the retrieved memory and the prompt structure
    XCTAssertTrue(response.contains("forest"), "Response should include relevant memory content.")
    XCTAssertTrue(response.contains("sacred space") || response.contains("symbolic"), "Response should reflect symbolic language from ritual prompt.")
    XCTAssertFalse(response.contains("I’m not sure"), "Response should not fall back when memory is found.")
}