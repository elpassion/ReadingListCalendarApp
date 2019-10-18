import Combine
import Foundation
@testable import ReadingListCalendarApp

class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        SimplePublisher { subscriber in
            subscriber.receive(self.urls[key])
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        SimplePublisher { subscriber in
            self.urls[key] = url
            subscriber.receive()
            subscriber.receive(completion: .finished)
            return .empty()
        }.eraseToAnyPublisher()
    }
}
