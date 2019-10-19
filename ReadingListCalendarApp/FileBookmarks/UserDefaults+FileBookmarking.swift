import Combine
import Foundation

extension UserDefaults: FileBookmarking {
    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        CustomPublisher(request: { subscriber, _ in
            guard let data = self.object(forKey: key) as? Data else {
                _ = subscriber.receive(nil)
                subscriber.receive(completion: .finished)
                return
            }
            do {
                let url = try NSURL(
                    resolvingBookmarkData: data,
                    options: [.withoutUI, .withSecurityScope],
                    relativeTo: nil,
                    bookmarkDataIsStale: nil
                )
                _ = subscriber.receive(url as URL)
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }).eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        CustomPublisher(request: { subscriber, _ in
            do {
                let data = try url?.bookmarkData(
                    options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )
                self.set(data, forKey: key)
                _ = subscriber.receive()
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
        }).eraseToAnyPublisher()
    }
}
