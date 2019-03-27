import Foundation

extension Bookmark {
    func readingListItems() throws -> [ReadingListItem] {
        guard let list = children?.first(where: { $0.isReadingList }) else {
            throw ReadingListError.readingListNotFound
        }
        guard let items = try list.children?.map({ try $0.readingListItem() }) else {
            throw ReadingListError.readingListItemsNotFound
        }
        return items
    }

    private var isReadingList: Bool {
        return title == "com.apple.ReadingList"
    }

    private func readingListItem() throws -> ReadingListItem {
        return ReadingListItem(
            uuid: uuid,
            title: try (uri?.title).or(ReadingListError.emptyTitle),
            url: try (url).or(ReadingListError.emptyURL),
            dateAdded: try (readingList?.dateAdded).or(ReadingListError.emptyDate),
            previewText: readingList?.previewText
        )
    }
}
