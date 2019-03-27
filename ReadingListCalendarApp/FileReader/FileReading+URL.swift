import Foundation

extension FileReading {
    func contents(atURL url: URL) -> Data? {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }
        return self.contents(atPath: url.path)
    }
}
