import AppKit

extension String {
    static var returnKeyEquivalent: String {
        String(utf16CodeUnits: [unichar(NSCarriageReturnCharacter)], count: 1)
    }
}
