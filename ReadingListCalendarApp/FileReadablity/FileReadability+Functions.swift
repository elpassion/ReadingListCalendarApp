import Foundation

func isReadableFile(_ fileReadability: FileReadablity) -> (URL?) -> Bool {
    return { url in url.map(fileReadability.isReadableFile(atURL:)) ?? false }
}

func fileReadabilityStatus(_ filename: String, _ fileReadability: FileReadablity) -> (URL?) -> String {
    return { url in
        guard let url = url else { return "" }
        guard fileReadability.isReadableFile(atURL: url) else { return "❌ \(filename) file is not readable" }
        return "✓ \(filename) file is set and readable"
    }
}
