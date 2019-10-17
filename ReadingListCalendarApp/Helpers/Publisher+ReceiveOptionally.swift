import Combine

extension Publisher {
    func receive<S>(
        optionallyOn scheduler: S?,
        options: S.SchedulerOptions? = nil
    ) -> AnyPublisher<Output, Failure> where S: Scheduler {
        guard let scheduler = scheduler else { return eraseToAnyPublisher() }
        return receive(on: scheduler, options: options).eraseToAnyPublisher()
    }
}
