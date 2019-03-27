import Foundation

enum BookmarksLoadingError: Error {
    case unableToLoad(URL)
    case decodingError(Error)
}
