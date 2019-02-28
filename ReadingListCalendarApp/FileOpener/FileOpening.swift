import Foundation

protocol FileOpening {
    func openFile(title: String, ext: String, url: URL?, completion: @escaping (URL?) -> Void)
}
