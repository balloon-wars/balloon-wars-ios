//
//  NetworkGames.swift
//  spitro
//
//  Created by Bruno Pastre on 21/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

class NetworkGame: Codable {
    
    enum Keys: String, CodingKey {
        case lastUpdate = "lastUpdate"
        case game = "game"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.lastUpdate = try container.decode(String.self, forKey: .lastUpdate)
        self.game = try container.decode(Game.self, forKey: .game)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(self.lastUpdate, forKey: .lastUpdate)
        try container.encode(self.game, forKey: .game)
    }
    
    
    var lastUpdate: String!
    var game: Game!
}
