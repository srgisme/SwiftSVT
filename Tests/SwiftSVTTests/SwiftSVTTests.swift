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

        let stateChangeSequence = CounterStateChange.increase
            .append(CounterStateChange.decrease)
            .append(AuthStateChange.login(token: "ABC123"))
            .append(CounterStateChange.decrease)
            .append(AuthStateChange.logout)
            .append(CounterStateChange.increase)
            .eraseToAnyPublisher()
        store.send(stateChangeSequence)
        wait(for: [expectation], timeout: 45)
    }

    static var allTests = [
        ("testChainingStoreTransactions", testChainingStoreTransactions),
    ]
    
}
