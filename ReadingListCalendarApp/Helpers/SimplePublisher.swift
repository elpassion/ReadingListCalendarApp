import Combine

public final class SimplePublisher<Output, Failure>: Publisher where Failure: Error {
    public init(_ closure: @escaping (Receiver<Output, Failure>) -> Disposable) {
        self.closure = closure
    }

    public func receive<S>(subscriber: S) where S: Subscriber, S.Input == Output, S.Failure == Failure {
        subscriber.receive(subscription: Subscription(subscriber: subscriber, closure: closure))
    }

    private let closure: (Receiver<Output, Failure>) -> Disposable

    public final class Receiver<Input, Failure> where Failure: Error {
        public init<S>(_ subscriber: S) where S: Subscriber, S.Input == Input, S.Failure == Failure {
            receiveInput = subscriber.receive(_:)
            receiveCompletion = subscriber.receive(completion:)
        }

        @discardableResult
        public func receive(_ input: Input) -> Subscribers.Demand {
            receiveInput(input)
        }

        public func receive(completion: Subscribers.Completion<Failure>) {
            receiveCompletion(completion)
        }

        private let receiveInput: (Input) -> Subscribers.Demand
        private let receiveCompletion: (Subscribers.Completion<Failure>) -> Void
    }

    public final class Disposable {
        public static func empty() -> Disposable {
            Disposable {}
        }

        public init(_ onDeinit: @escaping () -> Void) {
            self.onDeinit = onDeinit
        }

        deinit { onDeinit() }

        private let onDeinit: () -> Void
    }

    final class Subscription<SubscriberType, Input, Failure>: Combine.Subscription
    where SubscriberType: Subscriber, SubscriberType.Input == Input, SubscriberType.Failure == Failure {
        init(subscriber: SubscriberType, closure: @escaping (Receiver<Input, Failure>) -> Disposable) {
            self.subscriber = subscriber
            self.closure = closure
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > 0, let subscriber = subscriber else { return }
            disposables.append(closure(Receiver(subscriber)))
        }

        func cancel() {
            subscriber = nil
            disposables.removeAll()
        }

        private var subscriber: SubscriberType?
        private let closure: (Receiver<Input, Failure>) -> Disposable
        private var disposables = [Disposable]()
    }
}

public extension SimplePublisher.Receiver where Input == Void {
    @discardableResult
    func receive() -> Subscribers.Demand {
        receive(())
    }
}
