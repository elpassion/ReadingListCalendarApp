import Cocoa
import Combine
import EventKit

class AppDelegate: NSObject, NSApplicationDelegate {

    var launchArguments: [String] = CommandLine.arguments
    var appTerminator: AppTerminating = NSApplication.shared
    var mainWindowControllerFactory: MainWindowControllerCreating = MainWindowControllerFactory()
    var fileOpenerFactory: FileOpenerCreating = FileOpenerFactory()
    var fileBookmarks: FileBookmarking = UserDefaults.standard
    var fileReadability: FileReadablity = FileManager.default
    var calendarAuthorizer: CalendarAuthorizing = EKEventStore()
    var alertFactory: ModalAlertCreating = ModalAlertFactory()
    var calendarsProvider: CalendarsProviding = EKEventStore()
    var calendarIdStore: CalendarIdStoring = UserDefaults.standard
    var syncController: SyncControlling = SyncController()

    // MARK: NSApplicationDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        if !launchArguments.contains("-headless") {
            runApp()
        }
        if launchArguments.contains("-sync") {
            runSync()
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    // MARK: Private

    private var syncSubscription: AnyCancellable?

    private func runApp() {
        let controller = mainWindowControllerFactory.create(
            fileOpenerFactory: fileOpenerFactory,
            fileBookmarks: fileBookmarks,
            fileReadability: fileReadability,
            calendarAuthorizer: calendarAuthorizer,
            alertFactory: alertFactory,
            calendarsProvider: calendarsProvider,
            calendarIdStore: calendarIdStore,
            syncController: syncController
        )
        controller.showWindow(self)
    }

    private func runSync() {
        syncSubscription?.cancel()
        syncSubscription = nil

        let bookmarksURL = fileBookmarks.bookmarksFileURL()
            .compactMap { $0 }
            .eraseToAnyPublisher()

        let calendarId = calendarIdStore.calendarId()
            .compactMap { $0 }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()

        syncSubscription = Publishers
            .CombineLatest(bookmarksURL, calendarId)
            .flatMap(syncController.sync(bookmarksUrl:calendarId:))
            .sink(receiveCompletion: { [weak self] completion in
                if self?.launchArguments.contains("-headless") == true {
                    self?.appTerminator.terminate(nil)
                } else if case .failure(let error) = completion {
                    self?.alertFactory.createError(error).runModal()
                }
            }, receiveValue: { _ in })
    }

}
