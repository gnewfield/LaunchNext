import XCTest

final class ApplicationDirectoryScannerTests: XCTestCase {
    func testProtectedFolderDoesNotBlockReadableApps() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let protected = root.appendingPathComponent("Protected")
        try FileManager.default.createDirectory(at: protected, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.setAttributes([.posixPermissions: 0o700], ofItemAtPath: protected.path)
            try? FileManager.default.removeItem(at: root)
        }
        for name in ["Before.app", "After.app"] {
            try FileManager.default.createDirectory(at: root.appendingPathComponent(name), withIntermediateDirectories: true)
        }
        try FileManager.default.setAttributes([.posixPermissions: 0], ofItemAtPath: protected.path)

        let scan = ApplicationDirectoryScanner.scan(root)
        XCTAssertFalse(scan.isComplete, "An incomplete scan must never authorize layout removals")
        XCTAssertEqual(Set(scan.appURLs.map(\.lastPathComponent)), ["Before.app", "After.app"])
    }

    func testReadableEmptySourceIsComplete() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: root, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: root) }
        let scan = ApplicationDirectoryScanner.scan(root)
        XCTAssertTrue(scan.isComplete)
        XCTAssertTrue(scan.appURLs.isEmpty)
    }

    func testMissingSourceIsIncomplete() {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        let scan = ApplicationDirectoryScanner.scan(root)
        XCTAssertFalse(scan.isComplete)
        XCTAssertTrue(scan.appURLs.isEmpty)
    }
}
