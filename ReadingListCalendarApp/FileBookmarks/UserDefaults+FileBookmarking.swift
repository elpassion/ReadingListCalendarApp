import Combine
import Foundation

extension UserDefaults: FileBookmarking {
    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        SimplePublisher { subscriber in
            guard let data = self.object(forKey: key) as? Data else {
                subscriber.receive(nil)
                subscriber.receive(completion: .finished)
                return .empty()
            }
            do {
                let url = try NSURL(
                    resolvingBookmarkData: data,
                    options: [.withoutUI, .withSecurityScope],
                    relativeTo: nil,
                    bookmarkDataIsStale: nil
                )
                subscriber.receive(url as URL)
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
            return .empty()
        }.eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        SimplePublisher { subscriber in
            do {
                let data = try url?.bookmarkData(
                    options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )
                self.set(data, forKey: key)
                subscriber.receive()
                subscriber.receive(completion: .finished)
            } catch {
                subscriber.receive(completion: .failure(error))
            }
            return .empty()
        }.eraseToAnyPublisher()
    }
}
