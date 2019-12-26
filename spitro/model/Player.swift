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
    var needle: Needle
    
    var diameter: Float
    var radius: Float
    var life: Float
    
    enum Keys: String, CodingKey {
        
        case id = "id"
        case position = "position"
        case direction = "direction"
        case speed = "speed"
        case needle
        case diameter = "diameter"
        case radius = "radius"
        case life = "life"
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.position = try container.decode(Position.self, forKey: .position)
        self.direction = try container.decode(Float.self, forKey: .direction)
        self.speed = try container.decode(Float.self, forKey: .speed)
        
        self.needle = try container.decode(Needle.self, forKey: .needle)
        
        self.diameter = try container.decode(Float.self, forKey: .diameter)
        self.radius = try container.decode(Float.self, forKey: .radius)
        self.life = try container.decode(Float.self, forKey: .life)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.id, forKey: .id)
        try container.encode(self.position, forKey: .position)
        try container.encode(self.direction, forKey: .direction)
        try container.encode(self.speed, forKey: .speed)
        try container.encode(self.needle, forKey: .needle)
        
        try container.encode(self.diameter, forKey: .diameter)
        try container.encode(self.radius, forKey: .radius)
        try container.encode(self.life, forKey: .life)
    }
    
    
    func getNodeName() -> String {
        return "player" + self.id
    }
    
    func getNeedleNodeName() -> String {
        return "needle" + self.id
    }
}

 
