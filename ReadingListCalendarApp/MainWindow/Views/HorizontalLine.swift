import SwiftUI

struct HorizontalLine: View {

    var body: some View {
        Shape()
            .stroke()
            .foregroundColor(.gray)
            .opacity(0.3)
            .frame(minWidth: 0,
                   idealWidth: .infinity,
                   maxWidth: .infinity,
                   minHeight: 1,
                   idealHeight: 1,
                   maxHeight: 1)
    }

    private struct Shape: SwiftUI.Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            }
        }
    }

}
