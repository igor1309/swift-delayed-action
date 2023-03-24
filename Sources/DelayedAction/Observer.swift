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
