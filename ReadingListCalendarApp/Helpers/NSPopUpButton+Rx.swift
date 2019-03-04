import AppKit
import RxCocoa
import RxSwift

extension NSPopUpButton {}

extension Reactive where Base: NSPopUpButton {
    var updateItems: Binder<(titles: [String], selected: Int?)> {
        return Binder(base) { base, items in
            base.removeAllItems()
            base.addItems(withTitles: items.titles)
            base.selectItem(at: items.selected ?? -1)
        }
    }

    var selectedItemIndex: ControlEvent<Int> {
        return ControlEvent(events: controlEvent.map { [base] _ in base.indexOfSelectedItem })
    }
}
