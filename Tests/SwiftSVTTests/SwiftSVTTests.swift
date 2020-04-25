import Combine
@testable import SwiftSVT
import XCTest

final class SwiftSVTTests: XCTestCase {

    func testChainingStoreTransactions() {
        let store = Store(initialState: AppState())
        let expectation = XCTestExpectation()
        let cancellable = store.$state
            .print()
            .collect(7)
            .sink {
                XCTAssertEqual($0, [
                    AppState(),
                    AppState(counterState: .init(counter: 1), authenticationState: .unauthenticated),
                    AppState(counterState: .init(counter: 0), authenticationState: .unauthenticated),
                    AppState(counterState: .init(counter: 0), authenticationState: .authenticated("ABC123")),
                    AppState(counterState: .init(counter: -1), authenticationState: .authenticated("ABC123")),
                    AppState(counterState: .init(counter: -1), authenticationState: .unauthenticated),
                    AppState(counterState: .init(counter: 0), authenticationState: .unauthenticated)
                ])
                expectation.fulfill()
            }

        let transactionSequence = CounterStateTransaction.increase
            .then(CounterStateTransaction.decrease)
            .then(AuthStateTransaction(authStatus: .authenticated("ABC123")))
            .then(CounterStateTransaction.decrease)
            .then(AuthStateTransaction(authStatus: .unauthenticated))
            .then(CounterStateTransaction.increase)
        store.send(transactionSequence)
        wait(for: [expectation], timeout: 45)
    }

    static var allTests = [
        ("testChainingStoreTransactions", testChainingStoreTransactions),
    ]
    
}
