import AppKit

extension NSOpenPanel: FileOpening {
    func openFile(title: String, ext: String, url: URL?, completion: @escaping (URL) -> Void) {
        self.title = title
        canCreateDirectories = false
        showsHiddenFiles = true
        directoryURL = url
        allowedFileTypes = [ext]
        canChooseFiles = true
        canChooseDirectories = false
        allowsMultipleSelection = false
        begin { response in
            if let url = self.url, response == .OK {
                completion(url)
            }
        }
    }
}
