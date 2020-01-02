//
//  Needle.swift
//  spitro
//
//  Created by Bruno Pastre on 21/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class Needle: Codable {
    var position: Position
    var offset: Position
    var accDeltaTime: Float
    var isAttacking: Bool
    
    enum Keys: String, CodingKey {
        
        case position = "position"
        case offset = "offset"
        case accDeltaTime = "accDeltaTime"
        case isAttacking = "isAttacking"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        

        self.position = try container.decode(Position.self, forKey: .position)
        self.offset = try container.decode(Position.self, forKey: .offset)
        self.accDeltaTime = try container.decode(Float.self, forKey: .accDeltaTime)
        self.isAttacking = try container.decode(Bool.self, forKey: .isAttacking)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        
        try container.encode(self.position, forKey: .position)
        try container.encode(self.offset, forKey: .offset)
        try container.encode(self.accDeltaTime, forKey: .accDeltaTime)
        try container.encode(self.isAttacking, forKey: .isAttacking)
    }
}



