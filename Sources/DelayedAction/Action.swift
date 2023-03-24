//
//  Action.swift
//  
//
//  Created by Igor Malyarov on 25.03.2023.
//

public enum Action {
    
    case immediate
    case delayed(ms: Int)
}

extension Action {
    
    public var delayMS: Int {
        
        switch self {
        case .immediate:
            return 0
        case let .delayed(ms):
            return ms
        }
    }
    
    public var label: String {
        
        switch self {
        case .immediate:
            return "immediate"
            
        case .delayed:
            return "delayed"
        }
    }
}
