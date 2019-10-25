import AppKit
import SwiftUI

struct ReadingListView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("📚  Reading List")
                .font(.headline)
                .fontWeight(.medium)
            HorizontalLine()
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Text("/path/to/Bookmarks.plist")
                Spacer()
                Button(action: {}, label: {
                    Text("Change")
                })
            }
            Text("Bookmarks file access status")
        }
    }

}

#if DEBUG
struct ReadingListView_Previews: PreviewProvider {
    static var previews: some View {
        ReadingListView()
    }
}
#endif
