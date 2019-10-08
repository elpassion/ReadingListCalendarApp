import Foundation
@testable import ReadingListCalendarApp

class FileReadingDouble: FileReading {
    var mockedData: Data?
    private(set) var didReadContentsAtPath: String?

    func contents(atPath path: String) -> Data? {
        didReadContentsAtPath = path
        return mockedData
    }
}
