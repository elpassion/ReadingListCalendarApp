import AppKit
import SwiftUI

struct ProgressBar: NSViewRepresentable {

    let fractionCompleted: Double?

    func makeNSView(context: NSViewRepresentableContext<ProgressBar>) -> NSProgressIndicator {
        let nsView = NSProgressIndicator(frame: .zero)
        nsView.style = .bar
        nsView.isDisplayedWhenStopped = true
        nsView.minValue = 0
        nsView.maxValue = 100
        return nsView
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressBar>) {
        nsView.update(fractionCompleted: fractionCompleted)
    }

}
