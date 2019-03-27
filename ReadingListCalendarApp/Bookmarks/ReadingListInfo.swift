import Foundation

struct ReadingListInfo: Equatable, Decodable {
    let dateAdded: Date
    let previewText: String?

    enum CodingKeys: String, CodingKey {
        case dateAdded = "DateAdded"
        case previewText = "PreviewText"
    }
}
