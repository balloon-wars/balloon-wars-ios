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
    
    let manager = SocketManager(socketURL: URL(string:
        "http://192.168.100.27:5000")!,
                                
//        "https://balloon-wars-server.herokuapp.com")!,
        config: [.log(true), .compress, .forceNew(true), .reconnects(true), .reconnectWait(1), .reconnectWaitMax(2), .reconnectAttempts(-1)])
    
    
    func setupConnections() {
        let socket = getSocket()
        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

        socket.on("gameUpdate") {data, ack in
//            print("TYPE IS", type(of: data[0]))
            self.onGameUpdate(data[0] as! String)
//            print("Got a game update", data as! [[String: Any]])
//            self.onGameUpdate()
        }
        
        socket.connect()

    }
    
    private func onGameUpdate(_ json: String){
//        print("Json is", json)
        guard let newGame = try? JSONDecoder().decode(NetworkGame.self, from: json.data(using: .utf8)!) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        let serverTs = dateFormatter.date(from: newGame.lastUpdate)!
        
        print("Ping from server", Calendar.current.dateComponents([.nanosecond], from: serverTs, to: Date()).nanosecond! / 1000000)
        
        
        NotificationCenter.default.post(name: GAME_UPDATE_NOTIFICATION_NAME, object: nil, userInfo: ["game": newGame])
    }
    
    func getSocket() -> SocketIOClient {
        return self.manager.defaultSocket
    }
    
    func emit(_ event: String, message: [Any]) {
        
        getSocket().emit(event, with: message, completion: nil)
    }
}
