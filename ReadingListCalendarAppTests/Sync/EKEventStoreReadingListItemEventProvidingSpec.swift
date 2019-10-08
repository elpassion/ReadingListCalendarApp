import Quick
import Nimble
import EventKit
@testable import ReadingListCalendarApp

class EKEventStoreReadingListItemEventProvidingSpec: QuickSpec {
    override func spec() {
        describe("event store") {
            var sut: EKEventStoreDouble!

            beforeEach {
                sut = EKEventStoreDouble()
            }

            context("event for item in calendar") {
                var item: ReadingListItem!
                var calendar: EKCalendar!
                var event: EKEvent?

                beforeEach {
                    sut.mockedEvents = [
                        EKEvent(eventStore: sut),
                        EKEvent(eventStore: sut),
                        EKEvent(eventStore: sut)
                    ]
                    sut.mockedEvents[0].url = URL(string: "https://darrarski.pl")!
                    sut.mockedEvents[1].url = URL(string: "https://elpassion.com")!
                    sut.mockedEvents[2].url = URL(string: "https://elpassion.com")!
                    item = ReadingListItem(
                        uuid: "1234",
                        title: "Title",
                        url: "https://elpassion.com",
                        dateAdded: Date(),
                        previewText: "Preview Text"
                    )
                    calendar = EKCalendar(for: .event, eventStore: sut)
                    event = sut.event(for: item, in: calendar)
                }

                it("should create correct predicate") {
                    expect(sut.didCreatePredicateForEventsWithStartDate)
                        == Date(timeIntervalSince1970: item.dateAdded.timeIntervalSince1970 - 1)
                    expect(sut.didCreatePredicateForEventsWithEndDate)
                        == Date(timeIntervalSince1970: item.dateAdded.timeIntervalSince1970 + 1)
                    expect(sut.didCreatePredicateForEventsWithCalendars)
                        == [calendar]
                }

                it("should fetch events matching predicate") {
                    expect(sut.didFetchEventsMatchingPredicate) == sut.createdPredicate
                }

                it("should return correct event") {
                    expect(event) == sut.mockedEvents[1]
                }
            }
        }
    }
}
