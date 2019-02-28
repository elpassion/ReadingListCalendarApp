import Foundation

protocol FileBookmarking {
    func setFileURL(_ url: URL?, forKey key: String) throws
    func fileURL(forKey key: String) throws -> URL?
}
