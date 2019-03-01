import Foundation
import RxSwift

extension UserDefaults: FileBookmarking {

    func fileURL(forKey key: String) -> Single<URL?> {
        return Single<URL?>.create { observer in
            guard let data = self.object(forKey: key) as? Data else {
                observer(.success(nil))
                return Disposables.create()
            }
            do {
                let url = try NSURL(
                    resolvingBookmarkData: data,
                    options: [.withoutUI, .withSecurityScope],
                    relativeTo: nil,
                    bookmarkDataIsStale: nil
                )
                observer(.success(url as URL))
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func setFileURL(_ url: URL?, forKey key: String) -> Completable {
        return Completable.create { observer in
            do {
                let data = try url?.bookmarkData(
                    options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
                    includingResourceValuesForKeys: nil,
                    relativeTo: nil
                )
                self.set(data, forKey: key)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

}
