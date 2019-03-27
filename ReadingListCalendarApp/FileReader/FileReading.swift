import Foundation

protocol FileReading {
    func contents(atPath path: String) -> Data?
}
