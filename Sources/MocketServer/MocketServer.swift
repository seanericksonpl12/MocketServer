// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

public class Server {
    private var app: Application?

    public init() {}

    /// Starts the WebSocket server
    public func start(hostname: String = "127.0.0.1", port: Int = 8080) throws {
        // Ensure the server is not already running
        guard app == nil else {
            throw ServerError.alreadyRunning
        }

        // Create a new Vapor application with no command-line arguments
        var env = try Environment.detect()
        var app = Application(env)
        app.http.server.configuration.hostname = hostname
        app.http.server.configuration.port = port

        // Add WebSocket route
        app.webSocket("ws") { req, ws in
            print("WebSocket connected")
            ws.send("Welcome to the WebSocket server!")

            ws.onText { ws, text in
                print("Received: \(text)")
                ws.send("Echo: \(text)")
            }

            ws.onBinary { ws, binary in
                print("Received binary data of size: \(binary.capacity)")
            }

            ws.onClose.whenComplete { result in
                switch result {
                case .success:
                    print("WebSocket connection closed successfully")
                case .failure(let error):
                    print("WebSocket connection closed with error: \(error)")
                }
            }
        }

        // Start the server in a background thread
        DispatchQueue.global().async {
            do {
                try app.run()
            } catch {
                print("Failed to start server: \(error)")
            }
        }

        self.app = app
        print("Server started at ws://\(hostname):\(port)/ws")
    }

    /// Stops the WebSocket server
    public func stop() {
        app?.shutdown()
        app = nil
        print("Server stopped")
    }

    /// Error types for the server
    public enum ServerError: Error {
        case alreadyRunning
    }
}
