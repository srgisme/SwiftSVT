//
//  Store.swift
//  
//
//  Created by Scott Gorden on 2/1/20.
//

import Combine
import Foundation

/// `Reducer`s are publishers that publish closure elements that can modify your application's state. State changes should only happen here.
public typealias Reducer<State> = AnyPublisher<(inout State) -> Void, Never>

/// Your application should have only one `Store`. You can not subclass it, but it is generic over any app state type you want. Since the `Store` is an `ObservableObject`, any `View`s with an `@ObservedObject` (or `@EnvironmentObject`) property of this type will automatically be updated any time the `state` changes. If you want to prevent child `View`s from being updated upon `state` changes, wrap the parent `View` in an `EquatableView` (you can use the `equatable()` modifier on the parent as well).
final public class Store<State>: ObservableObject {
    /// The store's state.
    @Published public private(set) var state: State
    private var subscriptions: Set<AnyCancellable> = []

    public init(initialState: State) {
        self.state = initialState
    }

    /// This method is used to submit a `Reducer` publisher to the `Store` that subsequently mutates the store's state. When a `Reducer` is sent, the store subscribes to its publisher pipeline. Since the values submitted to the store are simply publishers, you have a lot of flexibility to design your `Reducer` publishers as you see fit.
    /// - Parameter reducer: The `Reducer` whose state changes are to be applied to the `Store`'s state
    /// - Important: You can only send `Reducer`s to the store when both the `Store`'s state and the state the transaction is mutating are of the same type.
    public func send<P: Publisher>(_ reducer: P) where P.Output == Reducer<State>.Output, P.Failure == Reducer<State>.Failure {
        reducer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                $0(&self.state)
                self.objectWillChange.send()
            }
            .store(in: &subscriptions)
    }

}
