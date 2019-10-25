import SwiftUI

struct StatusView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🔄  Status")
                .font(.headline)
                .fontWeight(.medium)
            HorizontalLine()
            Button(action: {}, label: {
                Text("Synchronize")
            }).frame(maxWidth: .infinity, alignment: .trailing)
            ProgressBar(fractionCompleted: 0.33)
                .padding(.top, 20)
        }
    }

}

#if DEBUG
struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
#endif
