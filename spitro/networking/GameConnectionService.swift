//
//  GameConnectionService.swift
//  spitro
//
//  Created by Bruno Pastre on 31/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import SocketIO

class GameConnectionService: ConnectionService {
    
    static let instance = GameConnectionService()
    
    func setup() {
        
        let socket = Connection.getSocket()
        
        socket.on("gameUpdate") {data, ack in
            self.onGameUpdate(data[0] as! String)
        }
        
    }
    
    
    private func onGameUpdate(_ json: String){
        guard let newGame = try? JSONDecoder().decode(NetworkGame.self, from: json.data(using: .utf8)!) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        
        let serverTs = dateFormatter.date(from: newGame.lastUpdate)!
        
        print("Ping from server", Calendar.current.dateComponents([.nanosecond], from: serverTs, to: Date()).nanosecond! / 1000000)
        
        
//        NotificationCenter.default.post(name: GAME_UPDATE_NOTIFICATION_NAME, object: nil, userInfo: ["game": newGame])
        
        EventBinder.trigger(event: .gameUpdate, payload: newGame)
    }
    
    
    static func updateDirection(to: Any) {
        Connection.emit("directionChanged", message: [to])
    }
    
    static func updateSpeed(to: Any) {
         Connection.emit("speedChanged", message: [to])
    }
    
    static func attack() {
        Connection.emit("startAttack", message: ["no message"])
    }
    
}
