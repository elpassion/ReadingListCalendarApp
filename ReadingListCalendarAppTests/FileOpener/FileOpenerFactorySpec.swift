import Quick
import Nimble
import Foundation
@testable import ReadingListCalendarApp

class FileOpenerFactorySpec: QuickSpec {
    override func spec() {
        describe("facotry") {
            var sut: FileOpenerFactory!

            beforeEach {
                sut = FileOpenerFactory()
                sut.openPanelFactory = NSOpenPanelDouble.init
            }

            context("create") {
                var title: String!
                var ext: String!
                var url: URL!
                var opener: FileOpening!

                beforeEach {
                    title = "Open File Title"
                    ext = "FileExtension"
                    url = URL(fileURLWithPath: "/tmp")
                    opener = sut.create(title: title, ext: ext, url: url)
                }

                it("should create NSOpenPanal") {
                    expect(opener).to(beAnInstanceOf(NSOpenPanelDouble.self))
                }

                it("should correctly configure opener") {
                    let openPanel = opener as? NSOpenPanelDouble
                    expect(openPanel?.title) == title
                    expect(openPanel?.canCreateDirectories) == false
                    expect(openPanel?.showsHiddenFiles) == true
                    expect(openPanel?.directoryURL) == url
                    expect(openPanel?.allowedFileTypes) == [ext]
                    expect(openPanel?.canChooseFiles) == true
                    expect(openPanel?.canChooseDirectories) == false
                    expect(openPanel?.allowsMultipleSelection) == false
                }
            }
        }
    }
}
