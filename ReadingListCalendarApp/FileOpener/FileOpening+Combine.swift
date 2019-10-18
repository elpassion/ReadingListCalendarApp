import Combine
import Foundation

extension FileOpening {
    func openFile() -> AnyPublisher<URL, Never> {
        SimplePublisher { subscriber in
            self.openFile { url in
                if let url = url {
                    subscriber.receive(url)
                }
                subscriber.receive(completion: .finished)
            }
            return .empty()
        }.eraseToAnyPublisher()
    }
}
