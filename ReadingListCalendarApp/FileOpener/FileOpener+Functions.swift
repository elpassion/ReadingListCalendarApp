import RxCocoa

func openBookmarksFile(_ openerFactory: FileOpenerCreating) -> () -> Driver<URL> {
    return {
        openerFactory.createBookmarksFileOpener()
            .rx_openFile()
            .asDriver(onErrorDriveWith: .empty())
    }
}
