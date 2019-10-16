import AppKit

let app = NSApplication.shared
let delegate = NSClassFromString("XCTestCase") == nil ? AppDelegate() : nil

app.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
