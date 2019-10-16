import Combine
import Foundation

protocol SyncControlling {
    func isSynchronizing() -> AnyPublisher<Bool, Never>
    func syncProgress() -> AnyPublisher<Double?, Never>
    func sync(bookmarksUrl: URL, calendarId: String) -> AnyPublisher<Void, Error>
}
