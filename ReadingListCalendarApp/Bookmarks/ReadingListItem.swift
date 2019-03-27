import Foundation

struct ReadingListItem: Equatable {
    let uuid: String
    let title: String
    let url: String
    let dateAdded: Date
    let previewText: String?
}
