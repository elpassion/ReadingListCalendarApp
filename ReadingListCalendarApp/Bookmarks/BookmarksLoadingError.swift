import Foundation

enum BookmarksLoadingError: Error {
    case unableToLoad(URL)
    case decodingError(Error)
}

extension BookmarksLoadingError: LocalizedError {
    var errorDescription: String? {
        return "Bookmarks Loading Error"
    }

    var failureReason: String? {
        switch self {
        case .unableToLoad(let url):
            return "Could not load reading list from \(url.absoluteString)"
        case .decodingError(let error):
            return "Could not decode bookmarks: \(error.localizedDescription)"
        }
    }
}
