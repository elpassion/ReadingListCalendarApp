import Combine
import Foundation

extension FileBookmarking {

    func bookmarksFileURL() -> AnyPublisher<URL?, Error> {
        fileURL(forKey: "bookmarks_file_url")
    }

    func setBookmarksFileURL(_ url: URL?) -> AnyPublisher<Void, Error> {
        setFileURL(url, forKey: "bookmarks_file_url")
    }

}
