/// A `BaggageContext` is a heterogeneous storage type with value semantics for keyed values in a type-safe
/// fashion. Its values are uniquely identified via `BaggageContextKey`s. These keys also dictate the type of
/// value allowed for a specific key-value pair through their associated type `Value`.
///
/// ## Subscript access
/// You may access the stored values by subscripting with a key type conforming to `BaggageContextKey`.
///
///     enum TestIDKey: BaggageContextKey {
///       typealias Value = String
///     }
///
///     var baggage = BaggageContext()
///     // set a new value
///     baggage[TestIDKey.self] = "abc"
///     // retrieve a stored value
///     baggage[TestIDKey.self] ?? "default"
///     // remove a stored value
///     baggage[TestIDKey.self] = nil
///
/// ## Convenience extensions
///
/// Libraries may also want to provide an extension, offering the values that users are expected to reach for
/// using the following pattern:
///
///     extension BaggageContext {
///       var testID: TestIDKey.Value {
///         get {
///           self[TestIDKey.self]
///         } set {
///           self[TestIDKey.self] = newValue
///         }
///       }
///     }
public struct BaggageContext {
    private var _storage = [ObjectIdentifier: ValueContainer]()

    /// Create an empty `BaggageContext`.
    public init() {}

    public subscript<Key: BaggageContextKey>(_ key: Key.Type) -> Key.Value? {
        get {
            self._storage[ObjectIdentifier(key)]?.forceUnwrap(key)
        } set {
            self._storage[ObjectIdentifier(key)] = newValue == nil ? nil : ValueContainer(value: newValue!)
        }
    }

    private struct ValueContainer {
        let value: Any

        func forceUnwrap<Key: BaggageContextKey>(_ key: Key.Type) -> Key.Value {
            self.value as! Key.Value
        }
    }
}

/// `BaggageContextKey`s are used as keys in a `BaggageContext`. Their associated type `Value` gurantees type-safety.
public protocol BaggageContextKey {
    /// The type of `Value` uniquely identified by this key.
    associatedtype Value
}