import AppKit

let app = NSApplication.shared
let delegate = NSClassFromString("XCTestCase") == nil ? AppDelegate() : nil

NSApplication.shared.delegate = delegate
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
