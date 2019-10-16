import Combine
import Foundation

extension UserDefaults: FileBookmarking {
    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error> {
        Future { complete in
            guard let data = self.object(forKey: key) as? Data else {
                complete(.success(nil))
                return
            }
            do {
                let url = try NSURL(
                    resolvingBookmarkData: data,
                    options: [.withoutUI, .withSecurityScope],
                    relativeTo: nil,
                    bookmarkDataIsStale: nil
                )
                complete(.success(url as URL))
            } catch {
                complete(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error> {
        Future { complete in
            do {
                let data = try url?.bookmarkData(
                    options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )
                self.set(data, forKey: key)
                complete(.success(()))
            } catch {
                complete(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
