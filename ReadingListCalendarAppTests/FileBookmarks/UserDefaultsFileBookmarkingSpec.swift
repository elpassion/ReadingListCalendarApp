import Quick
import Nimble
@testable import ReadingListCalendarApp

class UserDefaultsFileBookmarkingSpec: QuickSpec {
    override func spec() {
        describe("defaults") {
            var sut: UserDefaults!
            var key: String!

            beforeEach {
                sut = UserDefaults(suiteName: "tests")
                key = "test_file_bookmark_key"
                sut.removeObject(forKey: key)
            }

            it("should have no file url") {
                expect(try! sut.fileURL(forKey: key)).to(beNil())
            }

            context("set file url") {
                var url: URL!

                beforeEach {
                    url = try! NSURL(
                        resolvingAliasFileAt: URL(fileURLWithPath: "/tmp"),
                        options: [.withoutUI]
                    ) as URL
                    try! sut.setFileURL(url, forKey: key)
                }

                it("should have correct file url") {
                    expect(try! sut.fileURL(forKey: key)) == url
                }
            }
        }
    }
}
