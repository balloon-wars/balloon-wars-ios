//
//  PlayerNode.swift
//  spitro
//
//  Created by Bruno Pastre on 19/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class PlayerNode: SKSpriteNode {

//    var gunNode: SKShapeNode!
    var velocity: CGPoint?
    var angularRotation: CGFloat?
    
    var remotePlayerId: String!
    
    init(playerId: String, color: UIColor, size: CGSize = CGSize(width: 200, height: 200)) {
        
        
//        let texture = SKTexture(image: UIImage(named: "balloon")!)
        
        super.init(texture: nil, color: .orange, size: size)
        
        self.remotePlayerId = playerId
        self.name = playerId
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func updatePlayer(velocity newVelocity: CGPoint, rotation newRotation: CGFloat){
        
        self.position = newVelocity
        self.zRotation = newRotation
        
    }
    
}
