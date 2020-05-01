//
//  Store.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Combine
import Foundation

/// Your application should have only one `Store`. You can not subclass it, but it is generic over any app state type you want. Since the `Store` is an `ObservableObject`, any `View`s with an `@ObservedObject` (or `@EnvironmentObject`) property of this type will automatically be updated any time the `state` changes. If you want to prevent child `View`s from being updated upon `state` changes, wrap the parent `View` in an `EquatableView` (you can use the `equatable()` modifier on the parent as well).
final public class Store<State>: ObservableObject {
    /// A publisher that publishes a closure that takes a `StateType` as a parameter. Mutating the `Store`'s state should only happen inside this closure.
    public typealias StateChange = AnyPublisher<(inout State) -> Void, Never>
    /// The store's state.
    @Published public private(set) var state: State
    private var subscriptions: Set<AnyCancellable> = []

    public init(initialState: State) {
        self.state = initialState
    }

    /// This method is used to submit a `StateChange` to the `Store` and subsequently mutate the store's state. When a new state change is sent, the store subscribes to its publisher pipeline. Since the values submitted to the store are simply publishers, you have a lot of flexibility to design your state change publishers as you see fit.
    /// - Parameter stateChange: The state change to be applied to the `Store`'s state
    /// - Important: You can only send state changes to the store when both the `Store`'s state and the state the transaction is mutating are of the same type.
    public func send(_ stateChange: StateChange) {
        stateChange
            .receive(on: DispatchQueue.main)
            .print()
            .sink { [weak self] in
                guard let self = self else { return }
                $0(&self.state)
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }

}
