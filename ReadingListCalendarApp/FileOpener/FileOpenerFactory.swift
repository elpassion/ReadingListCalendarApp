import AppKit

struct FileOpenerFactory: FileOpenerCreating {
    var openPanelFactory: () -> NSOpenPanel = NSOpenPanel.init

    func create(title: String, ext: String, url: URL?) -> FileOpening {
        let opener = openPanelFactory()
        opener.title = title
        opener.canCreateDirectories = false
        opener.showsHiddenFiles = true
        opener.directoryURL = url
        opener.allowedFileTypes = [ext]
        opener.canChooseFiles = true
        opener.canChooseDirectories = false
        opener.allowsMultipleSelection = false
        return opener
    }
}
