import Combine
import Foundation

func openBookmarksFile(_ openerFactory: FileOpenerCreating) -> () -> AnyPublisher<URL, Never> {
    return {
        openerFactory.createBookmarksFileOpener().openFile()
    }
}
