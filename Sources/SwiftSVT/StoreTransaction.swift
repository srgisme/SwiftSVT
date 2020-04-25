import Combine
import Foundation

/// The protocol to which all store transactions must conform. State mutations are only allowed to be perform by types that conform to `StoreTransaction`.
public protocol StoreTransaction {
    associatedtype S: StateType
    /// A publisher that publishes a closure that takes a `StateType` as a paramter. Mutating the `Store`'s state should only happen inside this closure.
    /// - Important: You should not set this property (again) if you call `then(_:)` on a transaction.
    var reduce: AnyPublisher<(inout S) -> Void, Never> { get set }
}

extension StoreTransaction {
    /// This method is used to chain `StoreTransaction`s so they happen synchronously. This is a type-erasing procedure that Internally appends `transaction`'s `reduce` publisher to the receiver's `reduce` publisher.
    /// - Parameter transaction: the transaction to submit to the store after the receiver
    /// - Returns: a type-erased `AnyStoreTransaction` whose `reduce` publisher publishes elements from the receiver's `reduce` publisher followed by `transaction`'s `reduce` publisher.
    /// - Important: You can only use this method when both transactions are mutating the same state type
    public func then<T: StoreTransaction>(_ transaction: T) -> AnyStoreTransaction<T.S> where Self.S == T.S {
        var newTransaction = AnyStoreTransaction(self)
        newTransaction.reduce = newTransaction.reduce
            .append(transaction.reduce)
            .eraseToAnyPublisher()
        return newTransaction
    }
}

/// A type-erased concrete type that conforms to `StoreTransaction`. This type is used to hold the resulting `reduce` publisher from chained store transactions created by the `then(_:)` method.
public struct AnyStoreTransaction<TransactionState: StateType>: StoreTransaction {
    public var reduce: AnyPublisher<(inout TransactionState) -> Void, Never>

    init<T: StoreTransaction>(_ transaction: T) where TransactionState == T.S {
        self.reduce = transaction.reduce
    }
}
