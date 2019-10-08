import Foundation
@testable import ReadingListCalendarApp

class BookmarskLoadingDouble: BookmarksLoading {
    var mockedBookmarks = Bookmark.fake()
    private(set) var didLoadFromURL: URL?

    func load(fromURL url: URL) throws -> Bookmark {
        didLoadFromURL = url
        return mockedBookmarks
    }
}
