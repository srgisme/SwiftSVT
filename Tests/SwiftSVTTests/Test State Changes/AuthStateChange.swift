//
//  AuthStateChange.swift
//  
//
//  Created by Scott Gorden on 4/25/20.
//

import Combine
import Foundation
import SwiftSVT

enum AuthStateChange {
    static func login(token: String) -> Store<AppState>.StateChange {
        Just { state in
            state.authenticationState = .authenticated(token)
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    static var logout: Store<AppState>.StateChange {
        Just { state in
            state.authenticationState = .unauthenticated
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
