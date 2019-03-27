import Foundation

struct Bookmark: Equatable, Decodable {
    let uuid: String
    let title: String?
    let children: [Bookmark]?
    let uri: URIDict?
    let url: String?
    let readingList: ReadingListInfo?

    enum CodingKeys: String, CodingKey {
        case uuid = "WebBookmarkUUID"
        case children = "Children"
        case title = "Title"
        case uri = "URIDictionary"
        case url = "URLString"
        case readingList = "ReadingList"
    }
}
