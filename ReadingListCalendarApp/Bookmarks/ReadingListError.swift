import Foundation

enum ReadingListError: Error {
    case readingListNotFound
    case readingListItemsNotFound
    case emptyTitle
    case emptyURL
    case emptyDate
}

extension ReadingListError: LocalizedError {
    var errorDescription: String? {
        return "Reading List Error"
    }

    var failureReason: String? {
        switch self {
        case .readingListNotFound:
            return "List not found"
        case .readingListItemsNotFound:
            return "Items not found"
        case .emptyTitle:
            return "Item title not found"
        case .emptyURL:
            return "Item URL not found"
        case .emptyDate:
            return "Item date not found"
        }
    }
}
