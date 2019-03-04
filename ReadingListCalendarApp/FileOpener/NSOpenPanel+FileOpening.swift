import AppKit

extension NSOpenPanel: FileOpening {
    func openFile(completion: @escaping (URL?) -> Void) {
        begin { response in
            if response == .OK {
                completion(self.url)
            } else {
                completion(nil)
            }
        }
    }
}
