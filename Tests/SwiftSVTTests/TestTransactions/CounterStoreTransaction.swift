//
//  CounterStoreTransaction.swift
//  
//
//  Created by Scott Gorden on 4/24/20.
//

import Combine
import Foundation
import SwiftSVT

struct CounterStateTransaction: StoreTransaction {
    var reduce: AnyPublisher<(inout AppState) -> Void, Never>

    init(counterDelta: Int) {
        self.reduce = Just { state in
            state.counterState.counter += counterDelta
        }
        .delay(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

extension CounterStateTransaction {
    static var increase = CounterStateTransaction(counterDelta: 1)
    static var decrease = CounterStateTransaction(counterDelta: -1)
}
