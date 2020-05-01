# SwiftSVT

Store, View, Transaction. SwiftSVT is an easy to use app architecture built for SwiftUI and Combine. The library was inspired by Redux, but essentially combines the Reducer, Middleware, and Action into a `StateChange`. The gist is you send state changes to the store to modify state. Since state changes are publishers, you can create a publisher pipeline that publishes `(inout State) -> Void` closure elements to modify your application state.
