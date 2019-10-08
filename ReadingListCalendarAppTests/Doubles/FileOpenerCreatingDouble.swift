import AppKit
@testable import ReadingListCalendarApp

class FileOpenerCreatingDouble: FileOpenerCreating {
    var openerDouble = FileOpeningDouble()
    private(set) var didCreateWithTitle: String?
    private(set) var didCreateWithExt: String?
    private(set) var didCreateWithUrl: URL?

    func create(title: String, ext: String, url: URL?) -> FileOpening {
        didCreateWithTitle = title
        didCreateWithExt = ext
        didCreateWithUrl = url
        return openerDouble
    }
}
