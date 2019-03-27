import Foundation
@testable import ReadingListCalendarApp

extension Bookmark {
    static func fakeData() -> Data {
        let bundle = Bundle(for: BookmarksLoaderSpec.self)
        let path = bundle.path(forResource: "Bookmarks", ofType: "plist")!
        return FileManager.default.contents(atPath: path)!
    }

    static func fake() -> Bookmark {
        return try! PropertyListDecoder().decode(Bookmark.self, from: fakeData())
    }
}
