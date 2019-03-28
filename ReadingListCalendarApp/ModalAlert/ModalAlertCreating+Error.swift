import AppKit

extension ModalAlertCreating {
    func createError(_ error: Error) -> ModalAlert {
        return create(
            style: .critical,
            title: "Error occured",
            message: error.localizedDescription
        )
    }
}
