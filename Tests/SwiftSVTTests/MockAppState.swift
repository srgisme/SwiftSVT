//
//  MockAppState.swift
//  
//
//  Created by Scott Gorden on 4/24/20.
//

import Combine
import Foundation
import SwiftSVT

struct AppState: StateType, Equatable {
    var counterState = CounterState()
    var authenticationState = AuthenticationState.unauthenticated
}

struct CounterState: StateType, Equatable {
    var counter = 0
}

enum AuthenticationState: StateType, Equatable {
    case authenticated(String)
    case unauthenticated
}
