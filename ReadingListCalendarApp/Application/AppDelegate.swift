import Cocoa
import EventKit
import RxCocoa
import RxSwift

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

    private let disposeBag = DisposeBag()

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
        let bookmarksURL = fileBookmarks.bookmarksFileURL()
            .filter { $0 != nil }
            .map { $0! } // swiftlint:disable:this force_unwrapping
            .asObservable()

        let calendarId = calendarIdStore.calendarId()
            .filter { $0 != nil }
            .map { $0! } // swiftlint:disable:this force_unwrapping
            .asObservable()

        Observable.combineLatest(bookmarksURL, calendarId)
            .flatMap(syncController.sync(bookmarksUrl:calendarId:))
            .observeOn(MainScheduler.instance)
            .subscribe(onError: { [weak self] error in
                if self?.launchArguments.contains("-headless") == false {
                    self?.alertFactory.createError(error).runModal()
                }
            }, onDisposed: { [weak self] in
                if self?.launchArguments.contains("-headless") == true {
                    self?.appTerminator.terminate(nil)
                }
            })
            .disposed(by: disposeBag)
    }

}
