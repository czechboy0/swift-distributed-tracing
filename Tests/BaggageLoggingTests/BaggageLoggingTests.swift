import Baggage
import BaggageLogging
import Logging
import XCTest

final class BaggageLoggingTests: XCTestCase {
    func testItAddsMetadataToTheLogger() {
        var context = BaggageContext()
        let simpleTraceID = 42
        context[SimpleTraceIDKey.self] = 42
        let customTraceID = CustomTraceID(id: UUID(), name: "janedoe")
        context[CustomTraceIDKey.self] = customTraceID

        XCTAssertEqual(context.logger[metadataKey: "SimpleTraceIDKey"], "\(simpleTraceID)")
        XCTAssertEqual(context.logger[metadataKey: "CustomTraceIDKey"], "\(customTraceID)")
    }
}

enum SimpleTraceIDKey: BaggageContextKey {
    typealias Value = Int
}

struct CustomTraceID {
    let id: UUID
    let name: String
}

enum CustomTraceIDKey: BaggageContextKey {
    typealias Value = CustomTraceID
}
