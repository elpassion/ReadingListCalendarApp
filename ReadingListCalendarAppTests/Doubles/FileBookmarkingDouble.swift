import Combine
import Foundation
@testable import ReadingListCalendarApp

class FileBookmarkingDouble: FileBookmarking {
    var urls = [String: URL]()

    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        CustomPublisher(request: { subscriber, _ in
            _ = subscriber.receive(self.urls[key])
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        CustomPublisher(request: { subscriber, _ in
            self.urls[key] = url
            _ = subscriber.receive()
            subscriber.receive(completion: .finished)
        }).eraseToAnyPublisher()
    }
}
