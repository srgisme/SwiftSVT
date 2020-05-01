//
//  CounterStateChange.swift
//  
//
//  Created by Scott Gorden on 4/24/20.
//

import Combine
import Foundation
import SwiftSVT

enum CounterStateChange {
    private static func increase(delta: Int) -> Store<AppState>.StateChange {
        Just { state in
            state.counterState.counter += delta
        }
        .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    static var increase: Store<AppState>.StateChange {
        increase(delta: 1)
    }

    static var decrease: Store<AppState>.StateChange {
        increase(delta: -1)
    }
}
