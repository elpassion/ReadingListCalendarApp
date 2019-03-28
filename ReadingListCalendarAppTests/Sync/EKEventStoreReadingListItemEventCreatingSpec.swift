import Quick
import Nimble
import EventKit
@testable import ReadingListCalendarApp

class EKEventStoreReadingListItemEventCreatingSpec: QuickSpec {
    override func spec() {
        describe("event store") {
            var sut: EKEventStore!

            beforeEach {
                sut = EKEventStore()
            }

            context("create event for item in calendar") {
                var item: ReadingListItem!
                var calendar: EKCalendar!
                var event: EKEvent?

                beforeEach {
                    item = ReadingListItem(
                        uuid: "1234",
                        title: "Title",
                        url: "https://elpassion.com",
                        dateAdded: Date(),
                        previewText: "Preview Text"
                    )
                    calendar = EKCalendar(for: .event, eventStore: sut)
                    event = sut.createEvent(for: item, in: calendar)
                }

                it("should be correct") {
                    expect(event?.startDate).to(beCloseTo(item.dateAdded, within: 1))
                    expect(event?.endDate).to(beCloseTo(item.dateAdded, within: 1))
                    expect(event?.calendar) == calendar
                    expect(event?.url) == URL(string: item.url)
                    expect(event?.title) == item.title
                    expect(event?.notes) == item.previewText
                }
            }
        }
    }
}
