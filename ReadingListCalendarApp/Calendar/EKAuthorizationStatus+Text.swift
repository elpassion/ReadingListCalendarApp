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
            fallthrough
        @unknown default:
            return "❌ Callendar access denied"
        }
    }
}
