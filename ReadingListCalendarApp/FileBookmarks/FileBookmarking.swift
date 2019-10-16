import Combine
import Foundation
import RxSwift

protocol FileBookmarking {
    @available (*, deprecated, message: "Migreted to Combine")
    func fileURL(forKey key: String) -> Single<URL?>
    @available (*, deprecated, message: "Migreted to Combine")
    func setFileURL(_ url: URL?, forKey key: String) -> Completable

    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error>
    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error>
}
