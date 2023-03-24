//
//  Observer.swift
//  
//
//  Created by Igor Malyarov on 25.03.2023.
//

import Combine
import CombineSchedulers
import Foundation

public final class Observer {
    
    @Published public private(set) var actionString: String = ""
    
    public init(
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

private extension Action {
    
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
