//
//  Game.swift
//  spitro
//
//  Created by Bruno Pastre on 21/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class Game: Codable {
    
    var players: [Player]
    
    enum Keys: String, CodingKey {
        case players = "players"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.players = try container.decode([Player].self, forKey: .players)
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.players, forKey: .players)
        
    }
    
}
