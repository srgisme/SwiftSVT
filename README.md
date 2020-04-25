# SwiftSVT

Store, View, Transaction. SwiftSVT is an easy to use app architecture built for SwiftUI and Combine. The library was inspired by Redux, but essentially combines the Reducer, Middleware, and Action into a `StoreTransaction`. The gist is you send transactions to the Store to modify state. Inside the transactions is where you use Combine publishers to produce a closure that modifies your application state. You can even chain transactions to happen one after another.
