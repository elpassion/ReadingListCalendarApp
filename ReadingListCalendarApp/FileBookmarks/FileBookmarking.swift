import Foundation
import RxSwift

protocol FileBookmarking {
    func fileURL(forKey key: String) -> Single<URL?>
    func setFileURL(_ url: URL?, forKey key: String) -> Completable
}
