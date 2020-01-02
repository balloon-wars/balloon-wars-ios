//
//  Connection.swift
//  spitro
//
//  Created by Bruno Pastre on 18/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import SocketIO

let GAME_UPDATE_NOTIFICATION_NAME = NSNotification.Name("gameUpdate")

class Connection {
    
    static let manager = SocketManager(socketURL: URL(string:
        "http://192.168.100.27:5000")!,
//        "http://192.168.0.7:5000")!,
                                
//        "https://balloon-wars-server.herokuapp.com")!,
        
        config: [
//                .log(true),
                .compress,
                .forceNew(true),
                .reconnects(true),
                .reconnectWait(1),
                .reconnectWaitMax(2),
                .reconnectAttempts(-1)
    ])
    
    
    static func connect() {
        self.getSocket().connect()
    }
    
    static func getSocket() -> SocketIOClient {
        return self.manager.defaultSocket
    }
    
    static func getCurrentPlayerId() -> String {
        return self.getSocket().sid
    }

    static func emit(_ event: String, message: [Any]) {
        Connection.getSocket().emit(event, with: message, completion: nil)
    }
}
