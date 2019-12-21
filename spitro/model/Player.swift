//
//  Player.swift
//  spitro
//
//  Created by Bruno Pastre on 21/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class Player: Codable {
    var id: String
    var position: Position
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
        self.position = try container.decode(Position.self, forKey: .position)
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

