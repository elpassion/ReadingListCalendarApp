import SwiftUI

struct MainView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ReadingListView().padding(.bottom, 20)
            CalendarView().padding(.bottom, 20)
            StatusView()
        }.padding()
    }

}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
