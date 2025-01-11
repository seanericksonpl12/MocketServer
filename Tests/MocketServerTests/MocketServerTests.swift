import Testing
@testable import MocketServer

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let server = Server()
    try server.start(hostname: "127.0.0.1", port: 3000)
    
    try await Task.sleep(nanoseconds: 1_000_000_000_000)
}
