import Foundation

extension FileReadablity {
    func isReadableFile(atURL url: URL) -> Bool {
        _ = url.startAccessingSecurityScopedResource()
        defer { url.stopAccessingSecurityScopedResource() }
        return isReadableFile(atPath: url.path)
    }
}
