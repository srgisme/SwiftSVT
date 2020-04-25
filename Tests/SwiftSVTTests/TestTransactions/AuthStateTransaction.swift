//
//  AuthStateTransaction.swift
//  
//
//  Created by Scott Gorden on 4/25/20.
//

import Combine
import Foundation
import SwiftSVT

struct AuthStateTransaction: StoreTransaction {
    var reduce: AnyPublisher<(inout AppState) -> Void, Never>

    init(authStatus: AuthenticationState) {
        self.reduce = Just { state in
            state.authenticationState = authStatus
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
