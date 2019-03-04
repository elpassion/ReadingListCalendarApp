import Foundation

extension FileOpenerCreating {
    func createBookmarksFileOpener() -> FileOpening {
        return create(
            title: "Open Bookmarks.plist file",
            ext: "plist",
            url: URL(fileURLWithPath: "/Users/\(NSUserName())/Library/Safari/Bookmarks.plist")
        )
    }
}
