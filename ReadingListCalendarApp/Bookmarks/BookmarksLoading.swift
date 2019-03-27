import Foundation

protocol BookmarksLoading {
    func load(fromURL url: URL) throws -> Bookmark
}
