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
        
        
        let texture = SKTexture(image: UIImage(named: "balloon")!)
        
        super.init(texture: texture, color: color, size: size)
        
        self.remotePlayerId = playerId
        self.name = playerId
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
//
//    func update(){
//        let speed: CGFloat = 0.12
//        guard let angular = self.angularRotation else { return }
//        guard let pVelocity = self.velocity else { return }
//
//        if pVelocity.x != 0 && pVelocity.y != 0 && zRotation != angular {
//            self.zRotation = angular
//        }
//
//
//        let newPos = CGPoint(x: self.position.x + (pVelocity.x * speed), y: self.position.y + (pVelocity.y * speed))
//        guard newPos != self.position else { return }
//        self.position = newPos
//    }
    
    func updatePlayer(velocity newVelocity: CGPoint, rotation newRotation: CGFloat){
        
        self.position = newVelocity
        self.zRotation = newRotation
        
//        self.angularRotation = newRotation
//        self.velocity = newVelocity
    }
    
    func updateNeedle(position: CGPoint ) {
        print("-------> Setting needle position", position)
        self.gunNode.position = position
    }
    
}
