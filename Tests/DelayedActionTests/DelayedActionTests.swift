//
//  DelayedActionTests.swift
//  
//
//  Created by Igor Malyarov on 24.03.2023.
//
import Combine
import CombineSchedulers
import DelayedAction
import XCTest

final class DelayedActionTests: XCTestCase {
    
    func test_delayedAction_shouldBeDelayed() {
        
        let (_, spy, subject, scheduler) = makeSUT()
        XCTAssertEqual(spy.values, [])
        
        subject.send(.immediate)
        XCTAssertEqual(spy.values, [])
        
        scheduler.advance()
        XCTAssertEqual(spy.values, ["immediate"])
        
        subject.send(.delayed(ms: 200))
        XCTAssertEqual(spy.values, ["immediate"])
        
        scheduler.advance()
        XCTAssertEqual(spy.values, ["immediate"])

        scheduler.advance(by: .milliseconds(200))
        XCTAssertEqual(spy.values, ["immediate", "delayed"])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (
        sut: Observer,
        spy: ValueSpy<String>,
        subject: PassthroughSubject<Action, Never>,
        scheduler: TestSchedulerOf<DispatchQueue>
    ) {
        let subject = PassthroughSubject<Action, Never>()
        let scheduler = DispatchQueue.test
        let sut = Observer(
            subject.eraseToAnyPublisher(),
            scheduler: scheduler.eraseToAnyScheduler()
        )
        let spy = ValueSpy(sut.$actionString.dropFirst())

        trackForMemoryLeaks(subject)
        trackForMemoryLeaks(scheduler)
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(spy)
        
        return (sut, spy, subject, scheduler)
    }
}
