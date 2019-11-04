import SwiftUI

struct Button: NSViewRepresentable {

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    func keyEquivalent(_ keyEquivalent: String) -> Button {
        var copy = self
        copy.keyEquivalent = keyEquivalent
        return copy
    }

    private let title: String
    private let action: () -> Void
    private var keyEquivalent: String = ""

    // MARK: - NSViewRepresentable

    func makeNSView(context: NSViewRepresentableContext<Button>) -> NSButton {
        NSButton(
            title: title,
            target: context.coordinator,
            action: #selector(Coordinator.performAction)
        )
    }

    func updateNSView(_ nsView: NSButton, context: NSViewRepresentableContext<Button>) {
        nsView.title = title
        nsView.keyEquivalent = keyEquivalent
    }

    static func dismantleNSView(_ nsView: NSButton, coordinator: Button.Coordinator) {
        nsView.target = nil
        nsView.action = nil
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }

}

extension Button {
    class Coordinator {

        init(action: @escaping () -> Void) {
            self.action = action
        }

        @objc
        func performAction() {
            action()
        }

        private let action: () -> Void

    }
}
