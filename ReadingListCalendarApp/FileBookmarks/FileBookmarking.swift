import Combine
import Foundation

protocol FileBookmarking {
    func fileURL(forKey key: String) -> AnyPublisher<URL?, Error>
    func setFileURL(_ url: URL?, forKey key: String) -> AnyPublisher<Void, Error>
}
