//
//  Store.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Combine
import Foundation

/// Your application should have only one `Store`. You can not subclass it, but it is generic over any app state type you want. Since the `Store` is an `ObservableObject`, any `View`s with an `@ObservedObject` (or `@EnvironmentObject`) property of this type will automatically be updated any time the `state` changes. If you want to prevent child `View`s from being updated upon `state` changes, wrap the parent `View` in an `EquatableView` (you can use the `equatable()` modifier on the parent as well).
final public class Store<S: StateType>: ObservableObject {

    /// The store's state.
    @Published public private(set) var state: S
    private var subscriptions: Set<AnyCancellable> = []

    public init(initialState: S) {
        self.state = initialState
    }

    /// This method is used to submit a `StoreTransaction` to the `Store` and subsequently mutate the store's state. When a new transaction is sent, it is immediately performed. This is done asynchronously. If you would like to run transactions one after another (i.e. chaining), use the `then(_:)` method on `StoreTransaction`.
    /// - Parameter transaction: the transaction to be performed
    /// - Important: You can only send transactions to the store when both the `Store`'s state and the state the transaction is mutating are of the same type.
    public func send<T: StoreTransaction>(_ transaction: T) where T.S == S {
        Just(transaction)
            .flatMap(\.reduce)
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
