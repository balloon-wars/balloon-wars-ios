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

class _Position: Codable {
    var x: Float
    var y: Float
    
    
    enum Keys: String, CodingKey {
        case x = "x"
        case y = "y"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.x = try container.decode(Float.self, forKey: .x)
        self.y = try container.decode(Float.self, forKey: .y)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
    }
    
    
    func getCGPoint() -> CGPoint {
        return CGPoint(x: Double(self.x), y: Double(self.y))
    }
}

class _Player: Codable {
    var id: String
    var position: _Position
    var direction: Float
    var speed: Float
    
    enum Keys: String, CodingKey {
        
        case id = "id"
        case position = "position"
        case direction = "direction"
        case speed = "speed"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.position = try container.decode(_Position.self, forKey: .position)
        self.direction = try container.decode(Float.self, forKey: .direction)
        self.speed = try container.decode(Float.self, forKey: .speed)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.direction, forKey: .direction)
        try container.encode(self.speed, forKey: .speed)
    }
    
}
class _Game: Codable {
    
    var players: [_Player]
    
    enum Keys: String, CodingKey {
        case players = "players"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.players = try container.decode([_Player].self, forKey: .players)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.players, forKey: .players)
        
    }
    
}
class NetworkGame: Codable {
    
    enum Keys: String, CodingKey {
        case lastUpdate = "lastUpdate"
        case game = "game"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.lastUpdate = try container.decode(String.self, forKey: .lastUpdate)
        self.game = try container.decode(_Game.self, forKey: .game)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.lastUpdate, forKey: .lastUpdate)
        try container.encode(self.game, forKey: .game)
    }
    
    
    var lastUpdate: String!
    var game: _Game!
}

class Connection {
    
    let manager = SocketManager(socketURL: URL(string: "https://balloon-wars-server.herokuapp.com")!, config: [.log(true), .compress])

    
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
        let newGame = try! JSONDecoder().decode(NetworkGame.self, from: json.data(using: .utf8)!)
        
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
