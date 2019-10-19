import Combine
import Foundation

extension FileOpening {
    func openFile() -> AnyPublisher<URL, Never> {
        CustomPublisher(request: { subscriber, _ in
            self.openFile { url in
                if let url = url {
                    _ = subscriber.receive(url)
                }
                subscriber.receive(completion: .finished)
            }
        }).eraseToAnyPublisher()
    }
}
