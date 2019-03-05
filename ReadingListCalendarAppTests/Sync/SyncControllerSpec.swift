import Quick
import Nimble
import RxSwift
import RxCocoa
@testable import ReadingListCalendarApp

class SyncControllerSpec: QuickSpec {
    override func spec() {
        describe("instantiate") {
            var sut: SyncController!

            beforeEach {
                sut = SyncController()
            }

            context("sync") {
                var isSynchronizingEvents: [Bool]!
                var syncProgressEvents: [Double?]!
                var didComplete: Bool!

                beforeEach {
                    isSynchronizingEvents = []
                    _ = sut.isSynchronizing.asObservable()
                        .subscribe(onNext: { isSynchronizingEvents.append($0) })

                    syncProgressEvents = []
                    _ = sut.syncProgress.asObservable()
                        .subscribe(onNext: { syncProgressEvents.append($0) })

                    didComplete = false
                    _ = sut.sync(bookmarksUrl: URL(fileURLWithPath: ""), calendarId: "")
                        .subscribe(onCompleted: { didComplete = true })
                }

                afterEach {
                    isSynchronizingEvents = nil
                    syncProgressEvents = nil
                    didComplete = nil
                }

                it("should emit correct isSynchronizing events") {
                    expect(isSynchronizingEvents) == [false, true, false]
                }

                it("should emit correct syncProgress events") {
                    expect(syncProgressEvents) == [nil, 0, 1, nil]
                }

                it("should complete") {
                    expect(didComplete) == true
                }
            }
        }
    }
}
