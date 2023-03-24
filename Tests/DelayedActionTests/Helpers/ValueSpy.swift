//
//  ValueSpy.swift
//  
//
//  Created by Igor Malyarov on 24.03.2023.
//

import Combine
import Foundation

final class ValueSpy<Value: Equatable> {
    
    private(set) var values: [Value] = []
    private var cancellable: AnyCancellable?
    
    init<P>(
        _ publisher: P
    ) where P: Publisher, P.Output == Value, P.Failure == Never {
    
        cancellable = publisher.sink { [weak self] in
            
            self?.values.append($0)
        }
    }
}
