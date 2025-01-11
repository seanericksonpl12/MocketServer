// The Swift Programming Language
// https://docs.swift.org/swift-book

import Vapor

public class Server {
    
    private var app: Application?
    private var onText: ((String, ServerSocket) -> Void)?
    private var onClose: ((Result<Void, Error>) -> Void)?

    public init() {}

    /// Starts the WebSocket server
    public func start(hostname: String = "127.0.0.1", port: Int = 8080) throws {
        guard app == nil else {
            throw ServerError.alreadyRunning
        }

        let env = try Environment.detect()
        let app = Application(env)
        app.http.server.configuration.hostname = hostname
        app.http.server.configuration.port = port

        app.webSocket("ws") { req, ws in

            ws.onText { ws, text in
                self.onText?(text, ServerSocket(ws))
            }

            ws.onClose.whenComplete { result in
                self.onClose?(result)
            }
        }

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

    public func stop() {
        app?.shutdown()
        app = nil
    }

    public enum ServerError: Error {
        case alreadyRunning
    }
    
    public func onText(_ action: @escaping (String, ServerSocket) -> Void) {
        self.onText = action
    }
    
    public func onClose(_ action: @escaping (Result<Void, Error>) -> Void) {
        self.onClose = action
    }
}
