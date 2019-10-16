import Combine
import Foundation
import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    // TODO: Remove
    func fileURL(forKey key: String) -> Single<URL?> {
        return .just(urls[key])
    }

    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        Future { $0(.success(self.urls[key])) }.eraseToAnyPublisher()
    }

    // TODO: Remove
    func setFileURL(_ url: URL?, forKey key: String) -> Completable {
        urls[key] = url
        return .empty()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        Future {
            self.urls[key] = url
            $0(.success(()))
        }.eraseToAnyPublisher()
    }
}
