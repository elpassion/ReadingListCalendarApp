import Foundation
import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    func fileURL(forKey key: String) -> Single<URL?> {
        return .just(urls[key])
    }

    func setFileURL(_ url: URL?, forKey key: String) -> Completable {
        urls[key] = url
        return .empty()
    }
}
