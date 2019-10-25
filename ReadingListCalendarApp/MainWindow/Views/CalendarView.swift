import SwiftUI

struct CalendarView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("📅  Calendar")
                .font(.headline)
                .fontWeight(.medium)
            HorizontalLine()
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Authorization")
                Spacer()
                Button(action: {}, label: {
                    Text("Authorize")
                })
            }
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("Selected calendar")
                Spacer()
                Picker("", selection: $calendarId) {
                    Text("Personal").tag("calendar-a")
                    Text("Reading List").tag("calendar-b")
                    Text("Family").tag("calendar-c")
                }
            }
        }
    }

    @State private var calendarId: String = "calendar-b"

}

#if DEBUG
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
#endif
