@testable import ReadingListCalendarApp

class FileReadabilityDouble: FileReadablity {
    func isReadableFile(atPath path: String) -> Bool { return false }
}
