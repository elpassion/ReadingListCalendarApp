import Combine
import Foundation
@testable import ReadingListCalendarApp

class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        Future { $0(.success(self.urls[key])) }.eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        Future {
            self.urls[key] = url
            $0(.success(()))
        }.eraseToAnyPublisher()
    }
}
