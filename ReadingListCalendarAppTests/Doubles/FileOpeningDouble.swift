import Foundation
@testable import ReadingListCalendarApp

class FileOpeningDouble: FileOpening {
    private(set) var didBeginOpeningFile = false
    private(set) var openFileCompletion: ((URL?) -> Void)?

    func openFile(completion: @escaping (URL?) -> Void) {
        didBeginOpeningFile = true
        openFileCompletion = completion
    }
}
