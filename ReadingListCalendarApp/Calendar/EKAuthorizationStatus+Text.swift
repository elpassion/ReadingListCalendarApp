import EventKit

extension EKAuthorizationStatus {
    var text: String {
        switch self {
        case .authorized:
            return "✓ Callendar access authorized"
        case .notDetermined:
            return "❌ Callendar access not determined"
        case .restricted:
            return "❌ Callendar access restricted"
        case .denied:
            // swiftlint:disable:next no_fallthrough_only
            fallthrough
        @unknown default:
            return "❌ Callendar access denied"
        }
    }
}
