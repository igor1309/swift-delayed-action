//
//  DelayedActionTests.swift
//  
//
//  Created by Igor Malyarov on 24.03.2023.
//
import CasePaths
import Combine
import CombineSchedulers
import XCTest

enum Action {
    
    case immediate
    case delayed(ms: Int)
}

extension Action {
    
    var delayMS: Int {
        
        switch self {
        case .immediate:
            return 0
        case let .delayed(ms):
            return ms
        }
    }
    
    var label: String {
        
        switch self {
        case .immediate:
            return "immediate"
            
        case .delayed:
            return "delayed"
        }
    }
}

final class Observer {
    
    @Published private(set) var actionString: String = ""
    
    init(
        _ publisher: AnyPublisher<Action, Never>,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        publisher
            .flatMap {
                Just($0)
                    .delay(
                        for: .milliseconds($0.delayMS),
                        scheduler: scheduler
                    )
            }
            .map(\.label)
            .receive(on: scheduler)
            .assign(to: &$actionString)
    }
}

final class DelayedActionTests: XCTestCase {
    
    func test_delayedAction_shouldBeDelayed() {
        
        let subject = PassthroughSubject<Action, Never>()
        let scheduler = DispatchQueue.test
        let sut = Observer(
            subject.eraseToAnyPublisher(),
            scheduler: scheduler.eraseToAnyScheduler()
        )
        let spy = ValueSpy(sut.$actionString.dropFirst())
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
}
