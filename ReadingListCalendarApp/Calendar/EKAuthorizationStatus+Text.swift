import EventKit

extension EKAuthorizationStatus {
    var text: String {
        switch self {
        case .authorized:
            return "✓ Callendar access authorized"
        case .denied:
            return "❌ Callendar access denied"
        case .notDetermined:
            return "❌ Callendar access not determined"
        case .restricted:
            return "❌ Callendar access restricted"
        }
    }
}
