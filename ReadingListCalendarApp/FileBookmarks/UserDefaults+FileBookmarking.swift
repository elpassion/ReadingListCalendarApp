import Foundation

extension UserDefaults: FileBookmarking {

    func setFileURL(_ url: URL?, forKey key: String) throws {
        let data = try url?.bookmarkData(
            options: [.withSecurityScope, .securityScopeAllowOnlyReadAccess],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        set(data, forKey: key)
    }

    func fileURL(forKey key: String) throws -> URL? {
        guard let data = object(forKey: key) as? Data else { return nil }
        let url = try NSURL(
            resolvingBookmarkData: data,
            options: [.withoutUI, .withSecurityScope],
            relativeTo: nil,
            bookmarkDataIsStale: nil
        )
        return url as URL
    }

}
