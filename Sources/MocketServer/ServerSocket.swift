//
//  ServerSocket.swift
//  mocketserver
//
//  Created by Sean Erickson on 1/11/25.
//

import Vapor

public final class ServerSocket {
    
    private let ws: WebSocket
    
    internal init(_ ws: WebSocket) {
        self.ws = ws
    }
    
    public func send(_ message: String) {
        ws.send(message)
    }
    
    public func ping() {
        ws.sendPing()
    }
}
