import Foundation

protocol FileOpenerCreating {
    func create(title: String, ext: String, url: URL?) -> FileOpening
}
