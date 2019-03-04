import Foundation

protocol FileOpening {
    func openFile(completion: @escaping (URL?) -> Void)
}
