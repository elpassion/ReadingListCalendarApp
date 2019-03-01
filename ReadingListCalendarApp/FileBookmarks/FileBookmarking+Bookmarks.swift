import Foundation
import RxSwift

extension FileBookmarking {

    func bookmarksFileURL() -> Single<URL?> {
        return fileURL(forKey: "bookmarks_file_url")
    }

    func setBookmarksFileURL(_ url: URL?) -> Completable {
        return setFileURL(url, forKey: "bookmarks_file_url")
    }

}
