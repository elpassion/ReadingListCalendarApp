import Combine

public final class CustomPublisher<Output, Failure>: Publisher where Failure: Error {

    public init(subscribe subscribeClosure: @escaping (AnySubscriber<Output, Failure>) -> Subscription) {
        self.subscribeClosure = subscribeClosure
    }

    public convenience init(
        request requestClosure: @escaping (AnySubscriber<Output, Failure>, Subscribers.Demand) -> Void,
        cancel cancelClosure: @escaping () -> Void = {},
        deinit deinitClosure: @escaping () -> Void = {}
    ) {
        self.init { subscriber in
            Subscription(
                subscriber,
                request: requestClosure,
                cancel: cancelClosure,
                deinit: deinitClosure
            )
        }
    }

    public func receive<S>(subscriber: S) where S: Combine.Subscriber, S.Input == Output, S.Failure == Failure {
        let subscription = subscribeClosure(AnySubscriber(subscriber))
        subscriber.receive(subscription: subscription)
    }

    private let subscribeClosure: (AnySubscriber<Output, Failure>) -> Subscription

    public final class Subscription: Combine.Subscription {

        public init(
            _ subscriber: AnySubscriber<Output, Failure>,
            request requestClosure: @escaping (AnySubscriber<Output, Failure>, Subscribers.Demand) -> Void,
            cancel cancelClosure: @escaping () -> Void = {},
            deinit deinitClosure: @escaping () -> Void = {}
        ) {
            self.subscriber = subscriber
            self.requestClosure = requestClosure
            self.cancelClosure = cancelClosure
            self.deinitClosure = deinitClosure
        }

        deinit {
            deinitClosure()
        }

        public func request(_ demand: Subscribers.Demand) {
            if let subscriber = subscriber {
                requestClosure(subscriber, demand)
            }
        }

        public func cancel() {
            subscriber = nil
            cancelClosure()
        }

        private var subscriber: AnySubscriber<Output, Failure>?
        private let requestClosure: (AnySubscriber<Output, Failure>, Subscribers.Demand) -> Void
        private let cancelClosure: () -> Void
        private let deinitClosure: () -> Void

    }

}
