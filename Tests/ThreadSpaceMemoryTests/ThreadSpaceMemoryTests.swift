import XCTest
@testable import ThreadSpaceMemory

final class MemorySummaryServiceTests: XCTestCase {

    func testAddEntryStoresEntryWithTimestamp() throws {
        let service = MemorySummaryService()
        let content = "Today I learned about vector databases."
        service.addEntry(content)

        let entries = service.fetchAllEntries()
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.content, content)
        XCTAssertNotNil(entries.first?.timestamp)
    }

    func testSummarizeReturnsNonEmptyString() throws {
        let service = MemorySummaryService()
        service.addEntry("Visited the park.")
        service.addEntry("Had a good conversation with a friend.")
        service.addEntry("Worked on my ThreadSpace app.")

        let summary = service.summarize()
        XCTAssertFalse(summary.isEmpty, "Summary should not be empty")
        XCTAssertTrue(summary.contains("ThreadSpace") || summary.contains("park") || summary.contains("conversation"))
    }

    func testClearEntriesRemovesAllEntries() throws {
        let service = MemorySummaryService()
        service.addEntry("Temporary thought.")
        service.clearAllEntries()

        XCTAssertEqual(service.fetchAllEntries().count, 0)
    }
}