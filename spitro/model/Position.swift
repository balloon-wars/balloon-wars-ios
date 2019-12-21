//
//  Position.swift
//  spitro
//
//  Created by Bruno Pastre on 21/12/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import CoreGraphics

class Position: Codable {
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
