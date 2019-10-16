import AppKit
import Combine

extension NSPopUpButton {
    func updateItems(_ items: (titles: [String], selected: Int?)) {
        removeAllItems()
        let titles = items.titles.enumerated().map { "\($0.offset + 1). \($0.element)" }
        addItems(withTitles: titles)
        selectItem(at: items.selected ?? -1)
    }

    var selectedItemIndex: AnyPublisher<Int, Never> {
        publisher(for: \.indexOfSelectedItem).eraseToAnyPublisher()
    }
}
