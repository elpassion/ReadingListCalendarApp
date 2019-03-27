import Foundation

struct BookmarksLoader: BookmarksLoading {
    var fileReader: FileReading = FileManager.default

    func load(fromURL url: URL) throws -> Bookmark {
        guard let data = fileReader.contents(atURL: url) else {
            throw BookmarksLoadingError.unableToLoad(url)
        }
        let bookmarks: Bookmark
        do {
            bookmarks = try PropertyListDecoder().decode(Bookmark.self, from: data)
        } catch {
            throw BookmarksLoadingError.decodingError(error)
        }
        return bookmarks
    }
}
