import Foundation

func filePath(_ filename: String) -> (URL?) -> String {
    return { $0?.absoluteString ?? "❌ \(filename) file is not set" }
}
