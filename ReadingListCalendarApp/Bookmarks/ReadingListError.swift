import Foundation

enum ReadingListError: Error {
    case readingListNotFound
    case readingListItemsNotFound
    case emptyTitle
    case emptyURL
    case emptyDate
}
