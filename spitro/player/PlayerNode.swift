//
//  PlayerNode.swift
//  spitro
//
//  Created by Bruno Pastre on 19/09/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import SpriteKit

class PlayerNode: SKShapeNode {

    var velocity: CGPoint?
    var angularRotation: CGFloat?
    
    var remotePlayerId: String!
    
    init(playerId: String, color: UIColor, circleOfRadius radius: CGFloat) {
        
//        super.init(texture: nil, color: .orange, size: size)
        super.init()
        
        let rect = CGRect(x:-radius,y:-radius,width:radius * 2,height:radius * 2)
        self.path = CGPath(ellipseIn: rect, transform: nil)
        self.fillColor = color
        
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
