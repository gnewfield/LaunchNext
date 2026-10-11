import Foundation

struct ApplicationDirectoryScan {
    let appURLs: [URL]
    let isComplete: Bool
}

enum ApplicationDirectoryScanner {
    static func scan(_ directory: URL) -> ApplicationDirectoryScan {
        var isComplete = true
        guard let enumerator = FileManager.default.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants],
            errorHandler: { _, _ in
                isComplete = false
                // Keep discovering readable siblings after a protected subtree.
                return true
            }
        ) else {
            return ApplicationDirectoryScan(appURLs: [], isComplete: false)
        }

        var appURLs: [URL] = []
        for case let item as URL in enumerator where item.pathExtension == "app" {
            appURLs.append(item)
        }
        return ApplicationDirectoryScan(appURLs: appURLs, isComplete: isComplete)
    }
}
